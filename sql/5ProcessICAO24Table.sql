ALTER TABLE ICAO24 RENAME COLUMN Model TO Type;

DELETE FROM ICAO24 WHERE rowid = 1;

-- Remove the lines where there is no ICAOTypeCode
DELETE FROM ICAO24 WHERE IFNULL(ICAOTypeCode, '') = '';


ALTER TABLE ICAO24 ADD COLUMN Manufacturer TEXT;


UPDATE ICAO24
SET Manufacturer = (
    SELECT SUBSTR(ManufacturerAndModel, 1, INSTR(ManufacturerAndModel, ',') - 1)
    FROM ICAOList
    WHERE ICAO24.ICAOTypeCode = ICAOList.ICAOTypeCode
       AND ManufacturerAndModel IS NOT NULL
       AND TRIM(ManufacturerAndModel) <> ''
    LIMIT 1
)
WHERE Manufacturer IS NULL OR TRIM(Manufacturer) = '';


UPDATE ICAO24
SET Type = COALESCE(
    UPPER(SUBSTR(Manufacturer, 1, 1)) || LOWER(SUBSTR(Manufacturer, 2)) || ' ', ''
) || COALESCE(
    (SELECT SUBSTR(ManufacturerAndModel, INSTR(ManufacturerAndModel, ',') + 2)
     FROM ICAOList
     WHERE ICAO24.ICAOTypeCode = ICAOList.ICAOTypeCode
        AND ManufacturerAndModel IS NOT NULL
        AND TRIM(ManufacturerAndModel) <> ''
     LIMIT 1), ''
)
WHERE (Type IS NULL OR TRIM(Type) = '' OR LENGTH(Type) <= 10);

-- Add RegisteredOwners column to ADSBx table
ALTER TABLE ICAO24 ADD COLUMN RegisteredOwners TEXT;

-- Add OperatorFlagCode column to ADSBx table
ALTER TABLE ICAO24 ADD COLUMN OperatorFlagCode TEXT;

-- Add UserNotes column and populate it 
ALTER TABLE ICAO24 ADD COLUMN UserNotes TEXT; 

-- Set initial values for the new columns
UPDATE ICAO24 SET RegisteredOwners = 'unknown', OperatorFlagCode = 'BLANK', UserNotes = 'Updated S2: ' || DATETIME('now');

