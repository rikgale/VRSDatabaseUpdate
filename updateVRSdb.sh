#!/bin/bash

# Define variables for file locations and names
base_path="/home/pi/VirtualRadarServer/VRS-Extras"
log_file="$base_path/DatabaseUpdateFiles/updateVRSdb.log"
database_path="$base_path/Databases/Database/modTemp.sqb"
csv_file="$base_path/DatabaseUpdateFiles/dbdata.csv"
table_name="ADSBx"
icao_list_url="https://raw.githubusercontent.com/rikgale/ICAOList/main/ICAOList.csv"
icao_list_file="$base_path/DatabaseUpdateFiles/ICAOList.csv"
icao_list_table_name="ICAOList"
icao24_txt_file="$base_path/DatabaseUpdateFiles/icao24plus.txt"
icao24_table_name="ICAO24"
icao_type_conversion_table_name="ICAOTypeConversion"
sqlite_output_file="$base_path/DatabaseUpdateFiles/sqlite_output.txt"
jp_database_path="$base_path/DatabaseUpdateFiles/JetProp.sqb"
jp_aircraft_table="Aircraft"
bj_database_path="$base_path/DatabaseUpdateFiles/BizJets.sqb"
bj_aircraft_table="Aircraft"
base_station_jp_aircraft_table="JPAircraft"
base_station_bj_aircraft_table="BJAircraft"
icao_type_conversion_csv="$base_path/DatabaseUpdateFiles/ICAOTypeConversion.csv"
icao_type_conversion_table_name="ICAOTypeConversion"
icao_type_conversion_url="https://raw.githubusercontent.com/rikgale/ICAOList/main/ICAOTypeConversion.csv"
mil_icao_op_lookup_csv="$base_path/DatabaseUpdateFiles/MilICAOOperatorLookUp.csv"
mil_type_op_lookup_table_name="MilICAOOperatorLookup"
mil_icao_op_lookup_url="https://raw.githubusercontent.com/rikgale/ICAOList/main/MilICAOOperatorLookUp.csv"
os_db_path="$base_path/DatabaseUpdateFiles/aircraftDatabase.csv"
os_db_table_name="OSkyData"
download_os_db_csv="https://opensky-network.org/datasets/metadata/aircraftDatabase.csv"
reg_prefix_list_url="https://raw.githubusercontent.com/rikgale/ICAOList/main/RegPrefixList.csv"
reg_prefix_list_csv="$base_path/DatabaseUpdateFiles/RegPrefixList.csv"
reg_prefix_list_table_name="RegPrefixList"
pa_db_url="https://raw.githubusercontent.com/sdr-enthusiasts/plane-alert-db/main/plane_images.csv"
pa_db_csv="$base_path/DatabaseUpdateFiles/plane_images.csv"
pa_db_table_name="PlaneImages"

# SQL file with variables
update_database_sql="$base_path/DatabaseUpdateFiles/sql/create_temp_database.sql"

# Logging function
log() {
  local message=$1
  echo "$(date +"%Y-%m-%d %H:%M:%S") - $message" >> "$log_file"
}

# Download file function with logging
download_file() {
  local url=$1
  local destination=$2
  log "Downloading $url to $destination"
  curl -o "$destination" "$url"
  log "Download completed."
}

# Function to check and delete a file if it exists
delete_if_exists() {
  local file=$1
  if [ -e "$file" ]; then
    rm "$file"
    log "Deleted file: $file"
  fi
}

# Delete old ICAOList.csv
delete_if_exists "$icao_list_file"

# Download the latest ICAOList.csv from GitHub
download_file "$icao_list_url" "$icao_list_file"

# Delete old plane_images.csv
delete_if_exists "$pa_db_csv"

# Download the latest plane_images.csv from GitHub
download_file "$pa_db_url" "$pa_db_csv"

# Delete old RegPrefixList.csv
delete_if_exists "$reg_prefix_list_csv"

# Download the latest RegPrefixList.csv from GitHub
download_file "$reg_prefix_list_url" "$reg_prefix_list_csv"

# Delete old MilICAOperatorLookup.csv
delete_if_exists "$mil_icao_op_lookup_csv"

# Download the latest MilICAOperatorLookup.csv from GitHub
download_file "$mil_icao_op_lookup_url" "$mil_icao_op_lookup_csv"

# Delete Old ICAOTypeConversion.csv
delete_if_exists "$icao_type_conversion_csv"

# Download the latest ICAOTypeConversion.csv from GitHub
download_file "$icao_type_conversion_url" "$icao_type_conversion_csv"

# Check if aircraftDatabase.csv (OpenSky) exists and delete it if it does
delete_if_exists "$os_db_path"

# Download the aircraftDatabase.csv (OpenSky) using the download_file function
download_file "$download_os_db_csv" "$os_db_path"

# Check id modTemp.sqb exists and delete it if it does
delete_if_exists "$database_path"

# Check if dbdata.csv exists
if [ ! -e "$csv_file" ]; then
  log "Error: dbdata.csv does not exist. Exiting script."
  exit 1
fi

# Check if icao24plus.txt exists
if [ ! -e "$icao24_txt_file" ]; then
  log "Error: icao24plus.txt does not exist. Exiting script."
  exit 1
fi

# Check if ICAOTypeConversion.csv exists
if [ ! -e "$icao_type_conversion_csv" ]; then
  log "Error: ICAOTypeConversion.csv does not exist. Exiting script."
  exit 1
fi

# Check if MilICAOOperatorLookup.csv exists
if [ ! -e "$mil_icao_op_lookup_csv" ]; then
  log "Error: MilICAOOperatorLookup.csv does not exist. Exiting script."
  exit 1
fi

# Check if aircraftDatabase.csv exists
if [ ! -e "$os_db_path" ]; then
  log "Error: aircraftDatabase.csv does not exist. Exiting script."
  exit 1
fi

# Check if RegprefixList.csv exists
if [ ! -e "$reg_prefix_list_csv" ]; then
  log "Error: $reg_prefix_list_csv does not exist. Exiting script."
  exit 1
fi

# Check if plane_images.csv exists
if [ ! -e "$pa_db_csv" ]; then
  log "Error: $pa_db_csv does not exist. Exiting script."
  exit 1
fi



# Run SQLite commands with logging
log "Starting SQLite commands."

# Execute SQL commands from the separate file
sqlite3 "$database_path" << EOF > "$sqlite_output_file" 2>> "$log_file"
-- sql_commands.sql

PRAGMA locking_mode=EXCLUSIVE;
PRAGMA busy_timeout=500000;


-- This section imports ADSBx data from dbdata.csv file
-- Create a new table with the same column names as the CSV file
CREATE TABLE IF NOT EXISTS "$table_name" AS
  SELECT * FROM (SELECT * FROM csv('$csv_file') WHERE 1=0) AS temp_table;

-- Import data from CSV file into the new table
.mode csv
.import "$csv_file" "$table_name"


-- This section imports List of ICAO codes from ICAOList.csv
-- Create a new table for ICAOList
CREATE TABLE IF NOT EXISTS "$icao_list_table_name" (
  ICAOTypeCode TEXT,
  Class TEXT,
  NumberAndEngine TEXT,
  ManufacturerAndModel TEXT
);

-- Import data from ICAOList.csv into the new table
.mode csv
.import "$icao_list_file" "$icao_list_table_name"


-- This section imports List of Registration Prefixes from Regprefixlist.csv
-- Create a new table for ICAOList
CREATE TABLE IF NOT EXISTS "$reg_prefix_list_table_name" (
  Country TEXT,
  RegPrefix TEXT,
  Notes TEXT
);

-- Import data from Regprefixlist.csv into the new table
.mode csv
.import "$reg_prefix_list_csv" "$reg_prefix_list_table_name"


-- This section imports List of Plane Images URL from plane_images.csv
-- Create a new table for ICAOList
CREATE TABLE IF NOT EXISTS "$pa_db_table_name" (
  ModeS TEXT,
  PictureURL1 TEXT,
  PictureURL2 TEXT,
  PictureURL3 TEXT
);

-- Import data from plane_iamges.csv into the new table
.mode csv
.import "$pa_db_csv" "$pa_db_table_name"


-- This setion imports OpenSky data from downloaded file aircraftData.csv
-- Create a new table for OSkyData
CREATE TABLE IF NOT EXISTS "$os_db_table_name" AS
  SELECT * FROM (SELECT * FROM csv('$os_db_path') WHERE 1=0) AS temp_table;

-- Import data from aircraftDatabase.CSV file into the new table
.mode csv
.import "$os_db_path" "$os_db_table_name"


-- This section imports data from icao24plus.txt
-- Create a new table for ICAO24
CREATE TABLE IF NOT EXISTS "$icao24_table_name" (
  ModeS TEXT,
  Registration TEXT,
  ICAOTypeCode TEXT,
  Model TEXT
);

-- Import data from icao24plus.txt into the new table
.mode tabs
.import "$icao24_txt_file" "$icao24_table_name"


-- This section imports data for the ICAO Type Conversions
-- Create a new table for ICAOTypeConversion
CREATE TABLE IF NOT EXISTS "$icao_type_conversion_table_name" AS
  SELECT * FROM (SELECT * FROM csv('$icao_type_conversion_csv') WHERE 1=0) AS temp_table;

-- Import data from ICAOTypeConversion.csv into the new table
.mode csv
.import "$icao_type_conversion_csv" "$icao_type_conversion_table_name"


-- This section handles Military ICAO operator lookups and imports them
-- Create a new table for MilICAOOperatorLookup with the same column names as the CSV file
CREATE TABLE IF NOT EXISTS "$mil_type_op_lookup_table_name" AS
  SELECT * FROM (SELECT * FROM csv('$mil_icao_op_lookup_csv') WHERE 1=0) AS temp_table;

-- Import data from CSV file into the new table
.mode csv
.import "$mil_icao_op_lookup_csv" "$mil_type_op_lookup_table_name"


-- The setions below import the Aircraft table from the two attached databases BJAircraft and JPAircraft

-- Attach the BJ database
ATTACH DATABASE '$bj_database_path' AS bj_db;

-- Create a new table for BJAircraft
CREATE TABLE IF NOT EXISTS "$base_station_bj_aircraft_table" AS
  SELECT * FROM bj_db."$bj_aircraft_table";

DETACH DATABASE bj_db;

-- Attach the JP database
ATTACH DATABASE '$jp_database_path' AS jp_db;

-- Create a new table for JPAircraft
CREATE TABLE IF NOT EXISTS "$base_station_jp_aircraft_table" AS
  SELECT * FROM jp_db."$jp_aircraft_table";

DETACH DATABASE jp_db;


-- End of SQL commands

EOF

log "SQLite commands completed."
cat "$sqlite_output_file"
