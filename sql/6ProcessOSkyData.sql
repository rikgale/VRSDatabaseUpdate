-- Create a new table with the desired column names
CREATE TABLE "OSkyData_temp" AS
SELECT
    "icao24" AS "ModeS",
    "registration" AS "Registration",
    "manufacturername" AS "Manufacturer",
    "typecode" AS "ICAOTypeCode",
    "model" AS "Type",
    "operator" AS "RegisteredOwners",
    "serialnumber" AS "SerialNo",
    "operatoricao" AS "OperatorFlagCode",
    "built" AS "YearBuilt"
FROM "OSkyData";

-- Drop the original table
DROP TABLE IF EXISTS "OSkyData";

-- Rename the temporary table to the original table name 
ALTER TABLE "OSkyData_temp" RENAME TO "OSkyData";

-- Delete blank/NULL ICAO types
DELETE FROM "OSkyData"
WHERE TRIM(IFNULL("ICAOTypeCode", '')) = '';

-- CAPITALISE all ICAO Hex
UPDATE "OSkyData"
SET "ModeS" = UPPER("ModeS");

-- Update Manufacture COLUMN
UPDATE OSkyData
SET Manufacturer = (
    SELECT SUBSTR(ManufacturerAndModel, 1, INSTR(ManufacturerAndModel, ',') - 1)
    FROM ICAOList
    WHERE OSkyData.ICAOTypeCode = ICAOList.ICAOTypeCode
       AND ManufacturerAndModel IS NOT NULL
       AND TRIM(ManufacturerAndModel) <> ''
    LIMIT 1
)
WHERE (Manufacturer IS NULL OR TRIM(Manufacturer) = '')
   OR (OSkyData.ICAOTypeCode IN ('RV6', 'RV8', 'RV10', 'RV12', 'RV14', 'RV4', 'RV3', 'RV15', 'RV7', 'RV9'));

-- Remove () and contents from Type Field
UPDATE OSkyData
SET Type = TRIM(REPLACE(Type, SUBSTR(Type, INSTR(Type, '('), INSTR(Type, ')') - INSTR(Type, '(') + 1), ''))
WHERE Type IS NOT NULL AND Type LIKE '%(%' AND Type LIKE '%)%';

-- Update Type COLUMN
UPDATE OSkyData
SET Type = COALESCE(
    UPPER(SUBSTR(Manufacturer, 1, 1)) || LOWER(SUBSTR(Manufacturer, 2)) || ' ', ''
) || COALESCE(
    (SELECT SUBSTR(ManufacturerAndModel, INSTR(ManufacturerAndModel, ',') + 2)
     FROM ICAOList
     WHERE OSkyData.ICAOTypeCode = ICAOList.ICAOTypeCode
        AND ManufacturerAndModel IS NOT NULL
        AND TRIM(ManufacturerAndModel) <> ''
     LIMIT 1), ''
)
WHERE IFNULL(TRIM(Type), '') = '' OR LENGTH(TRIM(Type)) <= 12
   AND OSkyData.ICAOTypeCode NOT IN ('ZZZZ', 'GLID')
   AND (IFNULL(TRIM(Type), '') = '' OR LENGTH(TRIM(Type)) <= 12);

-- Update YearBuilt COLUMN
UPDATE OSkyData
SET YearBuilt = CASE
    WHEN IFNULL(YearBuilt, '') <> '' THEN SUBSTR(YearBuilt, 1, 4)
    ELSE ''
END;

-- Update OperatorFlagCode COLUMN when 4 or more char
UPDATE OSkyData
SET OperatorFlagCode = CASE
    WHEN LENGTH(TRIM(OperatorFlagCode)) >= 4 THEN ''
    ELSE TRIM(OperatorFlagCode)
END;

-- Update OperatorFlagCode to empty when it contains '-'
UPDATE OSkyData
SET OperatorFlagCode = ''
WHERE OperatorFlagCode LIKE '%-%';

-- Set OperatorFlagCode to all be uppercase 
UPDATE OSkyData 
SET OperatorFlagCode = UPPER(TRIM(OperatorFlagCode));

-- Combine OperatorFlagCode with a hyphen and ICAOTypeCode where OperatorFlagCode is not blank or NULL
UPDATE OSkyData
SET OperatorFlagCode = CASE
    WHEN IFNULL(TRIM(OperatorFlagCode), '') <> '' THEN UPPER(TRIM(OperatorFlagCode)) || '-' || ICAOTypeCode
    ELSE 'BLANK2'
END;

-- Add UserNotes column and populate it 
ALTER TABLE OSkyData ADD COLUMN UserNotes TEXT;
UPDATE OSkyData SET UserNotes = 'Updated S4 ' || DATETIME('now');