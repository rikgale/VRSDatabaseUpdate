-- Delete First row 
DELETE FROM "Miscode" WHERE rowid = 1;

--Drop Blank Cols used in import
ALTER TABLE "Miscode" DROP COLUMN "Blank1";
ALTER TABLE "Miscode" DROP COLUMN "Blank2";

-- Change HEX to ModeS
ALTER TABLE "Miscode" RENAME COLUMN "HEX" TO "CorrectModeS";

-- Change TypeICAO to ICAOTypeCode
ALTER TABLE "Miscode" RENAME COLUMN "Type ICAO" TO "ICAOTypeCode";

-- Change Type1 to Type
ALTER TABLE "Miscode" RENAME COLUMN "Type 1" TO "Type";

-- Change Operator to RegisteredOwners
ALTER TABLE "Miscode" RENAME COLUMN "Operator" TO "RegisteredOwners";

-- Change OprICAO to OperatorFlagCode
ALTER TABLE "Miscode" RENAME COLUMN "Opr ICAO" TO "OperatorFlagCode";

-- Change C/No to SerialNo
ALTER TABLE "Miscode" RENAME COLUMN "C/No" TO "SerialNo";

-- Change Year Built to YearBuilt
ALTER TABLE "Miscode" RENAME COLUMN "Year Built" TO "YearBuilt";

-- Change Year Built to YearBuilt
ALTER TABLE "Miscode" RENAME COLUMN "Reg'n" TO "Registration";

-- Delete rows where Miscode is null or an empty string 
DELETE FROM "Miscode" WHERE IFNULL("Miscode", '') = '';

-- Delete rows where Miscode contains non A-Z or 0-9 characters 
DELETE FROM "Miscode"
WHERE Miscode GLOB '*[^A-Za-z0-9]*';
