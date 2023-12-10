#!/bin/bash

base_path="/home/pi"
log_file="$base_path/VirtualRadarServer/VRS-Extras/DatabaseUpdateFiles/updateVRSdb.log"
database_path="$base_path/VirtualRadarServer/VRS-Extras/Databases/Database/modTemp.sqb"
base_station_database="$base_path/VirtualRadarServer/VRS-Extras/Databases/Database/BaseStation.sqb"
preprocess_sql_file="$base_path/VRSDatabaseUpdate/sql/10PreProcessAicraftTable.sql"
triggers_sql_file="$base_path/VRSDatabaseUpdate/sql/11Triggers.sql"
backup_name="BaseStation_Backup_$(date +%Y-%m-%d_%H-%M).sqb"
backup_path="$base_path/VirtualRadarServer/VRS-Extras/Databases/DatabaseBackup/$backup_name"


# Function to log messages to the file
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$log_file"
}


# Function to execute SQL commands from a file
execute_sql_file() {
    # Check if the SQL file exists before attempting to execute
    if [ -f "$1" ]; then
        sqlite3 "$base_station_database" < "$1" >> "$log_file" 2>&1
        log_message "Executed SQL commands from $1"
    else
        log_message "Error: SQL file $1 does not exist."
    fi
}


# Record start time for backup
backup_start_time=$(date +%s)

log_message "Creating backup of BaseStation database: $backup_name"

sqlite3 "$base_station_database" <<EOF
PRAGMA locking_mode=EXCLUSIVE;
PRAGMA busy_timeout=50000;
VACUUM INTO '$backup_path';
EOF

# Record end time for backup
backup_end_time=$(date +%s)
backup_elapsed_time=$((backup_end_time - backup_start_time))

log_message "BaseStation database backup completed: $backup_name"
log_message "Time taken for backup: $backup_elapsed_time seconds"


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

-- Copy and overwrite data in PictureURL1, PictureURL2, and PictureURL3 columns
UPDATE Aircraft
SET
    PictureURL1 = modTemp.PlaneImages.PictureURL1,
    PictureURL2 = modTemp.PlaneImages.PictureURL2,
    PictureURL3 = modTemp.PlaneImages.PictureURL3
FROM modTemp.PlaneImages
WHERE Aircraft.ModeS = modTemp.PlaneImages.ModeS;


-- Detach modTemp database
DETACH DATABASE modTemp;
EOF

log_message "Aicraft Table updated, Picture URLs updated"


# Execute SQL commands from the triggers file
log_message "Executing SQL commands from $triggers_sql_file"
execute_sql_file "$triggers_sql_file"
log_message "Trigger updated"

# VACUUM
log_message "Vaccum database"
sqlite3 "$base_station_database" <<EOF
PRAGMA locking_mode=EXCLUSIVE;
PRAGMA busy_timeout=500000;
VACUUM;
EOF

log_message "Vacuuming the main database completed"

# Delete modTemp.sqb file
# log_message "Deleting modTemp.sqb file"
# rm -f "$database_path"
# log_message "modTemp.sqb file deleted"

# Record end time
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))

# Log completion message and total time
log_message "Update process completed. Total time taken: $elapsed_time seconds"
