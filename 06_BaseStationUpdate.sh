#!/bin/bash

base_path="/home/pi"
backup_path_folder="$base_path/VirtualRadarServer/VRS-Extras/Databases/DatabaseBackup"
log_file="$base_path/VirtualRadarServer/VRS-Extras/DatabaseUpdateFiles/updateVRSdb.log"
database_path="$base_path/VirtualRadarServer/VRS-Extras/Databases/Database/modTemp.sqb"
base_station_database="$base_path/VirtualRadarServer/VRS-Extras/Databases/Database/BaseStation.sqb"
preprocess_sql_file="$base_path/VRSDatabaseUpdate/sql/20_PreProcessAicraftTable.sql"
triggers_sql_file="$base_path/VRSDatabaseUpdate/sql/30_Triggers.sql"
backup_name="BaseStation_Backup_$(date +%Y-%m-%d_%H-%M).sqb"
backup_path="$backup_path_folder/$backup_name"


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

# Delete everything in the backup folder
log_message "Deleting old backups: $backup_path_folder"
rm -rf "$backup_path_folder"/*.sqb

# Record start time for backup
backup_start_time=$(date +%s)

log_message "Creating backup of BaseStation database: $backup_name"

sqlite3 "$base_station_database" <<EOF
PRAGMA locking_mode=EXCLUSIVE;
PRAGMA busy_timeout=500000;
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
    YearBuilt = CASE
        WHEN Aircraft.YearBuilt IS NULL OR Aircraft.YearBuilt = '' OR Aircraft.YearBuilt != modTemp.FullAircraft.YearBuilt
        THEN modTemp.FullAircraft.YearBuilt
        ELSE Aircraft.YearBuilt
    END,
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
    YearBuilt, Status, Manufacturer, ICAOTypeCode, Type, SerialNo, RegisteredOwners,
    UserNotes, Interested, UserString1, UserString4, UserString5,
    UserInt1, UserInt3, OperatorFlagCode
)
SELECT
    FirstCreated, LastModified, ModeS, ModeSCountry, Country, Registration,
    YearBuilt, Status, Manufacturer, ICAOTypeCode, Type, SerialNo, RegisteredOwners,
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



-- Update OperatorFlagCode For Special Colours

-- Update OperatorFlagCode for entries with length 3 and meet the specified condition
UPDATE Aircraft
SET OperatorFlagCode = CASE
    WHEN LENGTH(Aircraft.OperatorFlagCode) = 3 THEN Aircraft.OperatorFlagCode || '-' || Aircraft.ICAOTypeCode || Aircraft.Registration
    ELSE Aircraft.OperatorFlagCode
END
FROM modTemp.OperatorFlags -- Use the attached database name as a prefix
WHERE Aircraft.Registration = modTemp.OperatorFlags.Registration
  AND Aircraft.OperatorFlagCode NOT LIKE '%' || Aircraft.Registration || '%';

-- Update OperatorFlagCode for entries with '-' as the 4th character
UPDATE Aircraft
SET OperatorFlagCode = OperatorFlagCode || Aircraft.Registration
FROM modTemp.OperatorFlags -- Use the attached database name as a prefix
WHERE Aircraft.Registration = modTemp.OperatorFlags.Registration
  AND SUBSTR(OperatorFlagCode, 4, 1) = '-'
  AND Aircraft.Registration = modTemp.OperatorFlags.Registration
  AND Aircraft.OperatorFlagCode NOT LIKE '%' || Aircraft.Registration || '%';

-- Update OperatorFlagCode for entries with 'BLANK' OperatorFlagCode
UPDATE Aircraft
SET OperatorFlagCode = REPLACE(modTemp.OperatorFlags.Name, '.bmp', '')
FROM modTemp.OperatorFlags -- Use the attached database name as a prefix
WHERE Aircraft.Registration = modTemp.OperatorFlags.Registration
  AND Aircraft.OperatorFlagCode = 'BLANK'
  AND Aircraft.Registration = modTemp.OperatorFlags.Registration
  AND Aircraft.OperatorFlagCode NOT LIKE '%' || Aircraft.Registration || '%';

-- Update LastModified to be equal to FirstCreated for those specials that are left
UPDATE Aircraft
SET LastModified = FirstCreated
FROM modTemp.OperatorFlags -- Use the attached database name as a prefix
WHERE Aircraft.Registration = modTemp.OperatorFlags.Registration
  AND Aircraft.OperatorFlagCode NOT LIKE '%' || Aircraft.Registration || '%';

-- Clean out any non A-Z, 0-9 ModeS that might have slipped through
DELETE FROM Aircraft
WHERE ModeS GLOB '*[^A-Za-z0-9]*';

-- Detach modTemp database
DETACH DATABASE modTemp;
EOF

log_message "Aicraft Table updated, Picture URLs updated"


# Execute SQL commands from the triggers file
log_message "Executing SQL commands from $triggers_sql_file"
execute_sql_file "$triggers_sql_file"

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
