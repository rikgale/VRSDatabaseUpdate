#!/bin/bash

base_path="/home/pi"
log_file="$base_path/VirtualRadarServer/VRS-Extras/DatabaseUpdateFiles/updateVRSdb.log"


# Check if the log file exists and delete it
if [ -e "$log_file" ]; then
    rm "$log_file"
    echo "Existing log file deleted."
fi


# Path to scripts
scripts_path="$base_path/VRSDatabaseUpdate"

# Function to log messages with timestamps
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$log_file"
}

log_message "Starting update process for BaseStation.sqb"

# Function to run a script and log the start and end times
run_script() {
    script_name=$1
    log_message "Starting $script_name"

    start_time=$(date +%s)
    "$scripts_path/$script_name"
    end_time=$(date +%s)

    runtime=$((end_time - start_time))
    log_message "Finished $script_name in $runtime seconds"
}

# Configurable script names
ADSB_script="01_ADSB_db_update.sh"
ICAO24_script="02_ICAO24_db_update.sh"
OSky_script="03_OSky_db_update.sh"
createmodTempdb_script="04_createmodTempdb.sh"
processmodTempdb_script="05_processmodTempdb.sh"
run_database_update_script="06_BaseStationUpdate.sh"
updateCountries_script="07_updateCountries.sh"

# Run scripts

total_start_time=$(date +%s)

run_script "$ADSB_script"
run_script "$ICAO24_script"
run_script "$OSky_script"
run_script "$createmodTempdb_script"
run_script "$processmodTempdb_script"
run_script "$run_database_update_script"
run_script "$updateCountries_script"

total_end_time=$(date +%s)
total_runtime=$((total_end_time - total_start_time))
log_message "Total runtime for all scripts to update BaseStation.sqb: $total_runtime seconds"
