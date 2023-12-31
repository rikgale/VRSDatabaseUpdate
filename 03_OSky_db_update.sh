#!/bin/bash

base_path="/home/pi/VirtualRadarServer/VRS-Extras"
os_db_path="$base_path/DatabaseUpdateFiles/aircraftDatabase.csv"
zip_url="https://opensky-network.org/datasets/metadata/aircraftDatabase.zip"
log_file="$base_path/DatabaseUpdateFiles/updateVRSdb.log"

# Function to log messages to the specified log file
log() {
  local log_message="$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $log_message" >> "$log_file"
}

log "Starting database update process."

# Record start time
start_time=$(date +%s)

# Check if aircraftDatabase.csv exists and delete it if it does
if [ -e "$os_db_path" ]; then
  log "Existing aircraftDatabase.csv found. Deleting it."
  rm "$os_db_path"
fi

# Create temporary directory for extraction
temp_dir=$(mktemp -d)

# Download the zip file
log "Downloading zip file from $zip_url."
wget -O "$temp_dir/aircraftDatabase.zip" "$zip_url"

# Extract the contents of the zip file
log "Extracting zip file."
unzip "$temp_dir/aircraftDatabase.zip" -d "$temp_dir"

# Find the CSV file and copy it to the desired location
log "Copying aircraftDatabase.csv to $os_db_path."
find "$temp_dir" -name 'aircraftDatabase.csv' -exec cp {} "$os_db_path" \;

# Clean up temporary directory
log "Cleaning up temporary directory."
rm -r "$temp_dir"

# Record end time
end_time=$(date +%s)

# Calculate duration and log it
duration=$((end_time - start_time))
log "Download and extraction completed. Duration: $duration seconds."
