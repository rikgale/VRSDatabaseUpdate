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
operator_flag_list_url="https://raw.githubusercontent.com/rikgale/VRSOperatorFlags/main/OperatorFlagsList.csv"
operator_flag_list_csv="$base_path/DatabaseUpdateFiles/operatorflags.csv"
operator_flag_table_name="OperatorFlags"
miscode_csv="$base_path/DatabaseUpdateFiles/Miscode.csv"
miscode_table_name="Miscode"
year_csv="$base_path/DatabaseUpdateFiles/Year.csv"
year_table_name="Year"

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

# Delete old OperatorFlags.csv
delete_if_exists "$operator_flag_list_csv"

# Download the latest ICAOList.csv from GitHub
download_file "$operator_flag_list_url" "$operator_flag_list_csv"


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

# Check if OperatorFlags.csv exists
if [ ! -e "$operator_flag_list_csv" ]; then
  log "Error: $operator_flag_list_csv does not exist. Exiting script."
  exit 1
fi

# Check if Year.csv exists
if [ ! -e "$year_csv" ]; then
  log "Error: $year_csv does not exist. Exiting script."
  exit 1
fi

# Check if Miscode.csv exists
if [ ! -e "$miscode_csv" ]; then
  log "Error: $miscode_csv does not exist. Exiting script."
  exit 1
fi


# Backup the original file just in case
cp "$miscode_csv" "$miscode_csv.bak"
log "Backup created: $miscode_csv.bak"

# Manually specify the encoding (ISO-8859-1 in this case, adjust if needed)
encoding="ISO-8859-1"

python3 -c "
import csv
import shutil

miscode_csv = '$miscode_csv'
encoding = '$encoding'.strip()

# Create a temporary file to write cleaned data
temp_output_file = miscode_csv + '.temp'

with open(miscode_csv, 'r', encoding=encoding, errors='replace') as infile, open(temp_output_file, 'w', encoding='utf-8', newline='') as outfile:
    reader = csv.reader(infile)
    writer = csv.writer(outfile)
    for row in reader:
        if len(row) >= 5:
            row[4] = ''.join(char for char in row[4] if char.isalnum() or char in ', ')
        writer.writerow(row)

# Replace the original file with the cleaned data
shutil.move(temp_output_file, miscode_csv)
"

log "Special characters removed from the 'Operator' column. Cleaned file saved to $miscode_csv"



# Run SQLite commands with logging
log "Starting SQLite commands."


# Import  ADSBx Database
log "Starting Import of ADSBx Database"

sqlite3 "$database_path" << EOF >> "$log_file" 2>&1


-- This section imports ADSBx data from dbdata.csv file
-- Create a new table with the same column names as the CSV file
CREATE TABLE IF NOT EXISTS "$table_name" AS
  SELECT * FROM (SELECT * FROM csv('$csv_file') WHERE 1=0) AS temp_table;

-- Import data from CSV file into the new table
.mode csv
.import "$csv_file" "$table_name"
EOF

log "Completed Import of ADSBx Database"


# Import ICAO Codes Table
log "Starting import of ICAO Codes Table"

sqlite3 "$database_path" << EOF >> "$log_file" 2>&1

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
EOF

log "Completed ICAO Code Table import"

# Import Registration Prefix
log "Starting import Registration Prefix table"

sqlite3 "$database_path" << EOF >> "$log_file" 2>&1

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
EOF

log "Completed Registration Prefix import"


# Import Years
log "Starting import Year table"

sqlite3 "$database_path" << EOF >> "$log_file" 2>&1

-- This section imports Years Year.csv
-- Create a new table for ICAOList
CREATE TABLE IF NOT EXISTS "$year_table_name" (
  "HEX" TEXT,
  "Reg'n" TEXT,
  "Type ICAO" TEXT,
  "Year Built" TEXT,
  "Blank1" TEXT,
  "Blank2" TEXT
);

-- Import data from Year.csv into the new table
.mode csv
.import "$year_csv" "$year_table_name"
EOF

log "Completed Year import"


# Import Miscode
log "Starting import Miscode table"

sqlite3 "$database_path" << EOF >> "$log_file" 2>&1

-- This section imports misocdes Miscode.csv
-- Create a new table for ICAOList
CREATE TABLE IF NOT EXISTS "$miscode_table_name" (
  "HEX" TEXT,
  "Type ICAO" TEXT,
  "Miscode" TEXT,
  "Type 1" TEXT,
  "Operator" TEXT,
  "Opr ICAO" TEXT,
  "C/No" TEXT,
  "Year Built" TEXT,
  "Reg'n" TEXT,
  "Blank1" TEXT,
  "Blank2" TEXT
);


-- Import data from Miscodes.csv into the new table
.mode csv
.import "$miscode_csv" "$miscode_table_name"
EOF

log "Completed Miscodes import"



# Import Plane Alert Images
log "Staring Import of PlaneAlert image URLs"

sqlite3 "$database_path" << EOF >> "$log_file" 2>&1
-- This section imports List of Plane Images URL from plane_images.csv
-- Create a new table for ICAOList
CREATE TABLE IF NOT EXISTS "$pa_db_table_name" (
  ModeS TEXT,
  PictureURL1 TEXT,
  PictureURL2 TEXT,
  PictureURL3 TEXT,
  PictureURL4 TEXT
);

-- Import data from plane_iamges.csv into the new table
.mode csv
.import "$pa_db_csv" "$pa_db_table_name"
EOF

log "Completed PlaneAlert image URLs import"


# Import OpenSky Database
log "Starting Import of Opensky Database"

sqlite3 "$database_path" << EOF >> "$log_file" 2>&1
-- This setion imports OpenSky data from downloaded file aircraftData.csv
-- Create a new table for OSkyData
CREATE TABLE IF NOT EXISTS "$os_db_table_name" AS
  SELECT * FROM (SELECT * FROM csv('$os_db_path') WHERE 1=0) AS temp_table;

-- Import data from aircraftDatabase.CSV file into the new table
.mode csv
.import "$os_db_path" "$os_db_table_name"
EOF

log "Completed OpenSky Database import"


# Import icao24plus.txt (Mictronics)
log "Starting Import of icao24plus"

sqlite3 "$database_path" << EOF >> "$log_file" 2>&1
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
EOF

log "Completed icao24plus import"



# Import ICAOType conversions
log "Starting import of ICAOType conversions"

sqlite3 "$database_path" << EOF >> "$log_file" 2>&1
-- This section imports data for the ICAO Type Conversions
-- Create a new table for ICAOTypeConversion
CREATE TABLE IF NOT EXISTS "$icao_type_conversion_table_name" AS
  SELECT * FROM (SELECT * FROM csv('$icao_type_conversion_csv') WHERE 1=0) AS temp_table;

-- Import data from ICAOTypeConversion.csv into the new table
.mode csv
.import "$icao_type_conversion_csv" "$icao_type_conversion_table_name"
EOF

log "Completed ICAOType conversion import"


# Import Military Operator ailine ICAO codes
log "Starting import of MilICAOOperatorLookup"

sqlite3 "$database_path" << EOF >> "$log_file" 2>&1
-- This section handles Military ICAO operator lookups and imports them
-- Create a new table for MilICAOOperatorLookup with the same column names as the CSV file
CREATE TABLE IF NOT EXISTS "$mil_type_op_lookup_table_name" AS
  SELECT * FROM (SELECT * FROM csv('$mil_icao_op_lookup_csv') WHERE 1=0) AS temp_table;

-- Import data from CSV file into the new table
.mode csv
.import "$mil_icao_op_lookup_csv" "$mil_type_op_lookup_table_name"
EOF

log "Completed MilICAOOperatorLookup import"


# Import Operator Flags List
log "Starting import of OperatorFlagsList"

sqlite3 "$database_path" << EOF >> "$log_file" 2>&1
-- This section handles Operator Flag lookups and imports them
-- Create a new table for Operater Flag with the same column names as the CSV fie
CREATE TABLE IF NOT EXISTS "$operator_flag_table_name" AS
  SELECT * FROM (SELECT * FROM csv('$operator_flag_list_csv') WHERE 1=0) AS temp_table;

-- Import data from CSV file into the new table
.mode csv
.import "$operator_flag_list_csv" "$operator_flag_table_name"
EOF

log "Completed Operator Flags import"




# Import PlaneBase data
log "Importing PlaneBase data from databases..."

# Import Bizjets
sqlite3 "$database_path" << EOF >> "$log_file" 2>&1
-- The setions below import the Aircraft table from the two attached databases BJAircraft and JPAircraft

-- Attach the BJ database
ATTACH DATABASE '$bj_database_path' AS bj_db;

-- Create a new table for BJAircraft
CREATE TABLE IF NOT EXISTS "$base_station_bj_aircraft_table" AS
  SELECT * FROM bj_db."$bj_aircraft_table";

DETACH DATABASE bj_db;
EOF

log "BizJets DB imported"


# Import JetProps

sqlite3 "$database_path" << EOF >> "$log_file" 2>&1
-- Attach the JP database
ATTACH DATABASE '$jp_database_path' AS jp_db;

-- Create a new table for JPAircraft
CREATE TABLE IF NOT EXISTS "$base_station_jp_aircraft_table" AS
  SELECT * FROM jp_db."$jp_aircraft_table";

DETACH DATABASE jp_db;
EOF

log "JetProp DB imported"

log "All SQLite commands completed."
