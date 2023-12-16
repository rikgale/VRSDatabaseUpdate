#!/usr/bin/python3

import csv
import sqlite3

# IMPORTANT: Run the script with the Basestation.sqb
#            and the Countries.dat files in the same directory!

# Store the name of the countries.dat file and the database in a variable
source = 'VirtualRadarServer/VRS-Extras/Databases/Database/Countries.dat'
database = 'VirtualRadarServer/VRS-Extras/Databases/Database/BaseStation.sqb'

# Create a dictionary of countries and bitmaps from the countries.dat file
countries = {}
with open(source, 'r') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    next(csv_reader)
    for line in csv_reader:
        raw_line = str(line[0])
        modes_country = raw_line[:raw_line.find('=')]
        pre_bit_mask = raw_line[raw_line.find('=')+1:]
        bitmask = pre_bit_mask.replace('x', '')
        dict_row = modes_country
        countries[bitmask] = modes_country


# recursively check the hexadecimal code in binary form against the dictionary
def modes_country(modes):
    modes = str(bin(int(modes, 16))[2:].zfill(24))
    x = range(24, 0, -1)
    for n in x:
        if countries.get(modes[:n], '') != '':
            return countries.get(modes[:n], '')

print('Step 1 - Set ModeSCountry field: ', end='')

# Connect to the database.
conn = sqlite3.connect(database)
c = conn.cursor()
# Step 1: Filling the blank ModeSCountry fields
with conn:
    # Set Pragma values for the database
    c.execute("""PRAGMA locking_mode=EXCLUSIVE""")
    c.execute("""PRAGMA busy_timeout=500000""")

    # Query only those hexadecimal codes that have an empty ModeSCountry field
    c.execute("""SELECT ModeS FROM Aircraft
                 WHERE NOT (ModeS LIKE '%O%' OR ModeS LIKE '%)%')
                 ORDER BY ModeS""")
    results = c.fetchall()

    # Extract the hexadecimal code from the result list one by one
    # Store the hexadecimal code in variable 'hex_code' and find the ModeSCountry
    # for that hexadecimal code and store the found country in the variable 'country'
    # than go to the next hexadecimal code in the result list
    for row in results:
        hex_code = str(row[0])
        country = modes_country(hex_code)

        # Update the aircraft table row for the hexadecimal code with the found country
        c.execute("""UPDATE Aircraft
                     SET ModeSCountry = :mc
                     WHERE ModeS = :hc""",
                  {'mc': country, 'hc': hex_code})
    conn.commit()
    print('Complete')

    # Step 2: Set the UserBool1 field to '0'
    print('Step 2 - Set UserBool1 to zero for all fields: ', end='')
    c.execute("""UPDATE Aircraft SET UserBool1 = 0""")
    conn.commit()
    print('Complete')

    # Step 3: Set the UserBool1 field to '1' if the ModeSCountry end with ' Mil'
    print('Step 3 - Set the UserBool1 field for military Mode-S codes: ', end='')
    c.execute("""UPDATE Aircraft SET UserBool1 = 1 WHERE ModeSCountry LIKE '% Mil'""")
    conn.commit()
    print('Complete')

    # Step 4: Normalize country names by removing ' Mil'
    print('Step 4 - Normalize country names: ', end='')
    c.execute("""UPDATE Aircraft SET ModeSCountry = REPLACE(ModeSCountry,' Mil','') WHERE ModeSCountry LIKE '% Mil'""")
    conn.commit()
    print('Complete')
print('Process completed.')

