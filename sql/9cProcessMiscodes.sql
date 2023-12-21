-- Change HEX to ModeS
ALTER TABLE "Miscode" RENAME COLUMN "HEX" TO "ModeS";

-- Change TypeICAO to ICAOTypeCode
ALTER TABLE "Miscode" RENAME COLUMN "Type ICAO" TO "ICAOTypeCode";

DELETE FROM "Miscode" WHERE IFNULL("ModeS", '') = '';
DELETE FROM "Miscode" WHERE IFNULL("Miscode", '') = '';
