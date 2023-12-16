#!/bin/bash

base_path="/home/pi"
log_file="$base_path/VirtualRadarServer/VRS-Extras/DatabaseUpdateFiles/updateVRSdb.log"
database_path="$base_path/VirtualRadarServer/VRS-Extras/Databases/Database/modTemp.sqb"
sql_path="$base_path/VRSDatabaseUpdate/sql"
locking_mode="EXCLUSIVE"
busy_timeout="500000"

# Function to log messages to the file
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$log_file"
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

# List of SQL files in the desired order
sql_files=(
    "1LookupAgainstICAOLookUp.sql"
    "2ProcessMilICAOOperatorLookUp.sql"
    "3aMilOperatorFlagCodeUpdates.sql"
    "3bOperatorFlagRegExtract.sql"
    "4ProcessADSBxTable.sql"
    "5ProcessICAO24Table.sql"
    "6ProcessOSkyData.sql"
    "6aProcessPATable.sql"
    "7CreateBasicAircraftPre.sql"
    "8CreatePBAircraft.sql"
    "9CreateFullAircraft.sql"
)

# Variable to track errors
errors=0

# Variable to track total time
total_time=0

# Iterate through SQL files in the specific order
for sql_file in "${sql_files[@]}"; do
    log_message "Starting execution of $sql_file"

    # Record start time
    start_time=$(date +%s)

    # Execute SQL file
    sqlite3 "$database_path" < "$sql_path/$sql_file" 2>> "$log_file"

    # Check for errors
    if [ $? -ne 0 ]; then
        log_message "Error executing $sql_file"
        errors=1
    else
        # Record end time
        end_time=$(date +%s)
        elapsed_time=$((end_time - start_time))
        total_time=$((total_time + elapsed_time))
        log_message "Finished $sql_file. Time taken: $elapsed_time seconds"
    fi
done

# Log success message and total time only if there were no errors
if [ $errors -eq 0 ]; then
    log_message "All SQL files executed successfully. Total time taken: $total_time seconds"
fi
