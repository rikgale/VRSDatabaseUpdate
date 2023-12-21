-- Change HEX to ModeS
ALTER TABLE "Year" RENAME COLUMN "HEX" TO "ModeS";

-- Change Regn to Registration
ALTER TABLE "Year" RENAME COLUMN "Reg'n" TO "Registration";

-- Change TypeICAO to ICAOTypeCode
ALTER TABLE "Year" RENAME COLUMN "Type ICAO" TO "ICAOTypeCode";

-- Change TypeICAO to ICAOTypeCode
ALTER TABLE "Year" RENAME COLUMN "Year Built" TO "YearBuilt";

-- Remove all rows where ModeS is empty or NULL using IFNULL
DELETE FROM "Year" WHERE IFNULL("ModeS", '') = '';

-- Remove all rows where ICAOTypeCode is empty or NULL using IFNULL
DELETE FROM "Year" WHERE IFNULL("ICAOTypeCode", '') = '';

-- Remove all rows where YearBuilt is empty or NULL using IFNULL
DELETE FROM "Year" WHERE IFNULL("YearBuilt", '') = '';

-- Extract only the year from YearBuilt, considering various formats 
UPDATE "Year" SET "YearBuilt" = SUBSTR("YearBuilt", -4) 
WHERE "YearBuilt" LIKE '%-____';

-- Extract only the year from YearBuilt, considering various formats 
UPDATE "Year" SET "YearBuilt" = SUBSTR("YearBuilt", -4) 
WHERE "YearBuilt" LIKE '% ____';

-- Extract only the year from YearBuilt, considering various formats 
UPDATE "Year" SET "YearBuilt" = SUBSTR("YearBuilt", -4) 
WHERE "YearBuilt" LIKE '%-____' OR "YearBuilt" LIKE '%/%/%';

-- Discard everything after and including the "/" character for various YYYY/Y formats
UPDATE "Year" SET "YearBuilt" = SUBSTR("YearBuilt", 1, 4) 
WHERE "YearBuilt" LIKE '____/%';

-- Keep only the 4 characters after the "/" in YearBuilt
UPDATE "Year" SET "YearBuilt" = SUBSTR("YearBuilt", INSTR("YearBuilt", '/') + 1, 4)
WHERE "YearBuilt" LIKE '%/%';

-- Remove rows where YearBuilt is not 4 characters long
DELETE FROM "Year" WHERE LENGTH("YearBuilt") != 4;



