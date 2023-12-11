#!/bin/bash

# Check if base_path argument is provided
if [ -z "$1" ]; then
    echo "Error: base_path argument is missing."
    exit 1
fi

base_path="$1"
 
# Set the base path
DATABASE_UPDATE_PATH="${BASE_PATH}/VirtualRadarServer/VRS-Extras/DatabaseUpdateFiles"
LOG_FILE="${DATABASE_UPDATE_PATH}/updateVRSdb.log"

# Ensure the DatabaseUpdateFiles directory exists
mkdir -p "$DATABASE_UPDATE_PATH"

# Function to log messages to the file
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}

# Set the URL and file paths
URL="https://downloads.adsbexchange.com/downloads/basic-ac-db.json.gz"
COMPRESSED_FILE="basic-ac-db.json.gz"
UNCOMPRESSED_FILE="basic-ac-db.json"
CSV_FILE="${DATABASE_UPDATE_PATH}/dbdata.csv"


# Record the start time
start_time=$(date +%s)

# Check if files exist and delete them
if [ -e "$COMPRESSED_FILE" ]; then
    rm "$COMPRESSED_FILE"
fi

if [ -e "$UNCOMPRESSED_FILE" ]; then
    rm "$UNCOMPRESSED_FILE"
fi

# Download the compressed JSON file
log_message "Downloading file from $URL"
wget "$URL" -O "$COMPRESSED_FILE"

# Check if the download was successful
if [ $? -eq 0 ]; then
    # Decompress the JSON file
    log_message "Decompressing file: $COMPRESSED_FILE"
    gunzip "$COMPRESSED_FILE"

    # Run the Python script
    log_message "Running Python script"
    python3 <<EOF


import json
# ====================================================================================================
# Keys (columns) imported from json file:
#-----------------------------------------------------------------------------------------------------
# icao
# reg
# icaotype
# year
# manufacturer
# model
# ownop
# faa_pia
# faa_ladd
# short_type
# mil

# Column mapping used for csv
# BaseStation.sqb   - jsonkey
#----------------------------
# ModeS             - icao
# Registration      - reg
# ICAOTypeCode      - icaotype
# Manufacturer      - manufacturer
# Type              - model
# UserBool1         - mil
# ====================================================================================================

print('Gererating CSV file')
jfile = 'basic-ac-db.json'
new_file = open('dbdata.csv', 'w')
new_file.write("ModeS,Registration,ICAOTypeCode,Manufacturer,Type,UserBool1\n")
fo = open(jfile, 'r')
while True:
    line = fo.readline()
    if not line:
        break
    jdict = json.loads(line)

    # Get the ICAO value and capitalize it if it is not None
    icao_value = jdict.get("icao")
    if icao_value is not None:
        icao_value = icao_value.upper()
        
    # Get the manufacturer value and remove commas
    manufacturer_value = jdict.get("manufacturer")
    if manufacturer_value is not None:
        manufacturer_value = manufacturer_value.replace(",", "")   

    nl = ('{},{},{},{},{},{}\n'
          .format
            (
            icao_value,
            (jdict.get("reg")),
            (jdict.get("icaotype")),
            manufacturer_value,
            (jdict.get("model")),
            (jdict.get("mil"))
            )
          )
    newline = nl.replace("None", "")
    new_file.write(newline)
fo.close()
new_file.close()




EOF

    # Move the generated CSV file to the desired location
    log_message "Moving CSV file to: $CSV_FILE"
    mv "dbdata.csv" "$CSV_FILE"

    # Record the end time and calculate duration
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    log_message "Process completed in $duration seconds"

    # Clean up: remove the downloaded compressed JSON file
    rm "$UNCOMPRESSED_FILE"
else
    log_message "Download failed. Exiting..."
fi
