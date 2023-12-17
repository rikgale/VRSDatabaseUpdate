
-- Remove the lines where there is no ICAOTypeCode
DELETE FROM ADSBx WHERE IFNULL(ICAOTypeCode, '') = '';


-- Where the Manufacturer is not populated add this from a look up to the ICAOList table from 
UPDATE ADSBx
SET Manufacturer = (
    SELECT SUBSTR(ManufacturerAndModel, 1, INSTR(ManufacturerAndModel, ',') - 1)
    FROM ICAOList
    WHERE ADSBx.ICAOTypeCode = ICAOList.ICAOTypeCode
       AND ManufacturerAndModel IS NOT NULL
       AND TRIM(ManufacturerAndModel) <> ''
    LIMIT 1
)
WHERE Manufacturer = '';

-- Where the Type is not populated add this from a look up to the ICAOList table from
UPDATE ADSBx
SET Type = (
    SELECT SUBSTR(ManufacturerAndModel, INSTR(ManufacturerAndModel, ',') + 2)
    FROM ICAOList
    WHERE ADSBx.ICAOTypeCode = ICAOList.ICAOTypeCode
       AND ManufacturerAndModel IS NOT NULL
       AND TRIM(ManufacturerAndModel) <> ''
    LIMIT 1
)
WHERE Type IS NULL OR TRIM(Type) = '';

-- Set Type column to combine Manufacturer and Type information
UPDATE ADSBx SET Type = Manufacturer || ' ' || Type;

-- Add RegisteredOwners column to ADSBx table
ALTER TABLE ADSBx ADD COLUMN RegisteredOwners TEXT;

-- Add OperatorFlagCode column to ADSBx table
ALTER TABLE ADSBx ADD COLUMN OperatorFlagCode TEXT;

-- Add UserNotes column and populate it 
ALTER TABLE ADSBx ADD COLUMN UserNotes TEXT;

-- Set initial values for the new columns
UPDATE ADSBx SET RegisteredOwners = 'Unknown', OperatorFlagCode = 'BLANK1', UserNotes = 'S3: ' || DATETIME('now');

