#!/bin/bash

base_path="/home/pi/VirtualRadarServer/VRS-Extras"
log_file="$base_path/DatabaseUpdateFiles/updateVRSdb.log"

# Path to scripts
scripts_path="/usr/local/bin"

# Function to log messages with timestamps
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$log_file"
}

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
ADSB_script="ADSB_db_update.sh"
ICAO24_script="ICAO24_db_update.sh"
createmodTempdb_script="createmodTempdb.sh"
processmodTempdb_script="processmodTempdb.sh"
run_database_update_script="run_database_update.sh"

# Run scripts
run_script "$ADSB_script"
run_script "$ICAO24_script"
run_script "$createmodTempdb_script"
run_script "$processmodTempdb_script"
run_script "$run_database_update_script"