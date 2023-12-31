#!/bin/bash

base_path="/home/pi/VirtualRadarServer/VRS-Extras"
os_db_path="$base_path/DatabaseUpdateFiles/aircraftDatabase.csv"
zip_url="https://opensky-network.org/datasets/metadata/aircraftDatabase.zip"

# Create temporary directory for extraction
temp_dir=$(mktemp -d)

# Download the zip file
wget -O "$temp_dir/aircraftDatabase.zip" "$zip_url"

# Extract the contents of the zip file
unzip "$temp_dir/aircraftDatabase.zip" -d "$temp_dir"

# Find the CSV file and copy it to the desired location
find "$temp_dir" -name 'aircraftDatabase.csv' -exec cp {} "$os_db_path" \;

# Clean up temporary directory
rm -r "$temp_dir"

echo "Download and extraction completed."
