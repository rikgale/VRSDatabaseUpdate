#!/bin/bash

base_path="/home/pi/VirtualRadarServer/VRS-Extras"
log_file="$base_path/DatabaseUpdateFiles/updateVRSdb.log"
database_path="$base_path/Databases/Database/modTemp.sqb"
base_station_database="$base_path/Databases/Database/BaseStation.sqb"
preprocess_sql_file="$base_path/DatabaseUpdateFiles/sql/10PreProcessAicraftTable.sql"

# Function to log messages to the file
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$log_file"
}

# Function to execute SQL commands from a file
execute_sql_file() {
    sqlite3 "$base_station_database" < "$1"
}

# Record start time
start_time=$(date +%s)

# Execute SQL commands from the preprocess file
log_message "Executing SQL commands from $preprocess_sql_file"
execute_sql_file "$preprocess_sql_file"

# Attach modTemp database to BaseStation.sqb and update Aircraft table
log_message "Attaching modTemp database to BaseStation.sqb and updating Aircraft table"

sqlite3 "$base_station_database" <<EOF
PRAGMA locking_mode=EXCLUSIVE;
PRAGMA busy_timeout=500000;
ATTACH DATABASE '$database_path' AS modTemp;

-- Update existing records in Aircraft from FullAircraft based on matching ModeS
UPDATE Aircraft
SET 
    FirstCreated = modTemp.FullAircraft.FirstCreated,
    LastModified = modTemp.FullAircraft.LastModified,
    Registration = modTemp.FullAircraft.Registration,
    Status = modTemp.FullAircraft.Status,
    Manufacturer = modTemp.FullAircraft.Manufacturer,
    ICAOTypeCode = modTemp.FullAircraft.ICAOTypeCode,
    Type = modTemp.FullAircraft.Type,
    SerialNo = modTemp.FullAircraft.SerialNo,
    RegisteredOwners = modTemp.FullAircraft.RegisteredOwners,
    UserNotes = modTemp.FullAircraft.UserNotes,
    Interested = modTemp.FullAircraft.Interested,
    UserString1 = modTemp.FullAircraft.UserString1,
    UserString4 = modTemp.FullAircraft.UserString4,
    UserString5 = modTemp.FullAircraft.UserString5,
    UserInt1 = modTemp.FullAircraft.UserInt1,
    UserInt3 = modTemp.FullAircraft.UserInt3,
    OperatorFlagCode = modTemp.FullAircraft.OperatorFlagCode
FROM modTemp.FullAircraft
WHERE Aircraft.ModeS = modTemp.FullAircraft.ModeS
AND Aircraft.FirstCreated = Aircraft.LastModified;

-- Insert new records into Aircraft from FullAircraft where they do not exist
INSERT INTO Aircraft (
    FirstCreated, LastModified, ModeS, ModeSCountry, Country, Registration,
    Status, Manufacturer, ICAOTypeCode, Type, SerialNo, RegisteredOwners,
    UserNotes, Interested, UserString1, UserString4, UserString5,
    UserInt1, UserInt3, OperatorFlagCode
)
SELECT 
    FirstCreated, LastModified, ModeS, ModeSCountry, Country, Registration,
    Status, Manufacturer, ICAOTypeCode, Type, SerialNo, RegisteredOwners,
    UserNotes, Interested, UserString1, UserString4, UserString5,
    UserInt1, UserInt3, OperatorFlagCode
FROM modTemp.FullAircraft
WHERE NOT EXISTS (
    SELECT 1
    FROM Aircraft
    WHERE Aircraft.ModeS = modTemp.FullAircraft.ModeS
);

-- Detach modTemp database
DETACH DATABASE modTemp;
EOF
# Record end time
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))

# Log completion message and total time
log_message "Update process completed. Total time taken: $elapsed_time seconds"
