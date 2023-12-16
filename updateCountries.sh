#!/bin/bash

base_path="/home/pi"
log_file="$base_path/VirtualRadarServer/VRS-Extras/DatabaseUpdateFiles/updateVRSdb.log"
file_url="https://raw.githubusercontent.com/rikgale/VRSCountries.dat/main/Countries.dat"
downloaded_file="$base_path/VirtualRadarServer/VRS-Extras/DatabaseUpdateFiles/Countries.dat"

# Check if the file exists and delete it
if [ -e "$downloaded_file" ]; then
    rm "$downloaded_file"
    echo "Deleted existing file: $downloaded_file" >> "$log_file"
fi

# Download the file and log output
wget -O "$downloaded_file" "$file_url" >> "$log_file" 2>&1

# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "File downloaded successfully." >> "$log_file"
else
    echo "Error downloading file. Check $log_file for details." >> "$log_file"
fi
