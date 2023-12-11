#!/bin/bash

# Check if base_path argument is provided
if [ -z "$1" ]; then
    echo "Error: base_path argument is missing."
    exit 1
fi

base_path="$1"

# Function to log messages to the file
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$log_file"
}

# Set the base path
###base_path="/home/pi"
log_file="$base_path/VirtualRadarServer/VRS-Extras/DatabaseUpdateFiles/updateVRSdb.log"
url="https://mictronics.de/aircraft-database/icao24plus.php"
output_zip="downloaded_file.zip"
target_folder="$base_path/VirtualRadarServer/VRS-Extras/DatabaseUpdateFiles"
license_file="LICENSE"
icao_file="icao24plus.txt"

# Record start time
start_time=$(date +"%s")

# Check if the license file exists before proceeding
if [ -f "$target_folder/$license_file" ]; then
    log_message "Deleting existing license file..."
    rm "$target_folder/$license_file"
fi

# Check if the icao file exists before proceeding
if [ -f "$target_folder/$icao_file" ]; then
    log_message "Deleting existing icao file..."
    rm "$target_folder/$icao_file"
fi

# Download the ZIP file
log_message "Downloading ZIP file..."
wget "$url" -O "$output_zip"

# Extract the contents of the ZIP file directly into the target folder
log_message "Extracting ZIP ICAO24 file..."
unzip -j "$output_zip" -d "$target_folder"

# Delete the license file
log_message "Deleting license file..."
rm "$target_folder/$license_file"

# Record end time
end_time=$(date +"%s")

# Calculate and log the duration
duration=$((end_time - start_time))
log_message "Process completed in $duration seconds."

# Clean up: Delete the ZIP file
log_message "Cleaning up..."
rm "$output_zip"
