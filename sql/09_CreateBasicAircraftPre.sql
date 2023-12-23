-- Create BasicAircraftPre table
CREATE TABLE IF NOT EXISTS BasicAircraftPre (
    "AircraftID" INTEGER,
    "FirstCreated" DATETIME NOT NULL,
    "LastModified" DATETIME NOT NULL,
    "ModeS" VARCHAR(6) NOT NULL UNIQUE,
    "ModeSCountry" VARCHAR(24),
    "Country" VARCHAR(24),
    "Registration" VARCHAR(20),
    "CurrentRegDate" VARCHAR(10),
    "PreviousID" VARCHAR(10),
    "FirstRegDate" VARCHAR(10),
    "Status" VARCHAR(10),
    "DeRegDate" VARCHAR(10),
    "Manufacturer" VARCHAR(60),
    "ICAOTypeCode" VARCHAR(10),
    "Type" VARCHAR(40),
    "SerialNo" VARCHAR(30),
    "PopularName" VARCHAR(20),
    "GenericName" VARCHAR(20),
    "AircraftClass" VARCHAR(20),
    "Engines" VARCHAR(40),
    "OwnershipStatus" VARCHAR(10),
    "RegisteredOwners" VARCHAR(100),
    "MTOW" VARCHAR(10),
    "TotalHours" VARCHAR(20),
    "YearBuilt" VARCHAR(4),
    "CofACategory" VARCHAR(30),
    "CofAExpiry" VARCHAR(10),
    "UserNotes" VARCHAR(300),
    "Interested" BOOLEAN NOT NULL DEFAULT 0,
    "UserTag" VARCHAR(5),
    "InfoURL" VARCHAR(150),
    "PictureURL1" VARCHAR(150),
    "PictureURL2" VARCHAR(150),
    "PictureURL3" VARCHAR(150),
    "UserBool1" BOOLEAN NOT NULL DEFAULT 0,
    "UserBool2" BOOLEAN NOT NULL DEFAULT 0,
    "UserBool3" BOOLEAN NOT NULL DEFAULT 0,
    "UserBool4" BOOLEAN NOT NULL DEFAULT 0,
    "UserBool5" BOOLEAN NOT NULL DEFAULT 0,
    "UserString1" VARCHAR(20),
    "UserString2" VARCHAR(20),
    "UserString3" VARCHAR(20),
    "UserString4" VARCHAR(20),
    "UserString5" VARCHAR(20),
    "UserInt1" INTEGER DEFAULT 0,
    "UserInt2" INTEGER DEFAULT 0,
    "UserInt3" INTEGER DEFAULT 0,
    "UserInt4" INTEGER DEFAULT 0,
    "UserInt5" INTEGER DEFAULT 0,
    "OperatorFlagCode" VARCHAR(20),
    PRIMARY KEY("AircraftID")
);

-- Copy data from ICAO24 to BasicAircraftPre
INSERT INTO BasicAircraftPre (
    "AircraftID", 
    "FirstCreated", 
    "LastModified", 
    "ModeS", 
    "Registration", 
    "ICAOTypeCode", 
    "Manufacturer", 
    "Type", 
    "RegisteredOwners", 
    "OperatorFlagCode", 
    "UserNotes"
)
SELECT 
    NULL, 
    CURRENT_TIMESTAMP, 
    CURRENT_TIMESTAMP, 
    I."ModeS", 
    I."Registration", 
    I."ICAOTypeCode", 
    I."Manufacturer", 
    I."Type", 
    I."RegisteredOwners", 
    I."OperatorFlagCode", 
    I."UserNotes"
FROM ICAO24 I;

-- Copy data from ADSBx to BasicAircraftPre where ModeS does not already exist
INSERT INTO BasicAircraftPre (
    "AircraftID", 
    "FirstCreated", 
    "LastModified", 
    "ModeS", 
    "Registration", 
    "ICAOTypeCode", 
    "Manufacturer", 
    "Type", 
    "RegisteredOwners", 
    "OperatorFlagCode", 
    "UserNotes"
)
SELECT 
    NULL, 
    CURRENT_TIMESTAMP, 
    CURRENT_TIMESTAMP, 
    A."ModeS", 
    A."Registration", 
    A."ICAOTypeCode", 
    A."Manufacturer", 
    A."Type", 
    A."RegisteredOwners", 
    A."OperatorFlagCode", 
    A."UserNotes"
FROM ADSBx A
WHERE A."ModeS" NOT IN (SELECT "ModeS" FROM BasicAircraftPre);

-- Copy data from OSkyData to BasicAircraftPre where ModeS does not already exist
INSERT INTO BasicAircraftPre (
    "AircraftID", 
    "FirstCreated", 
    "LastModified", 
    "ModeS", 
    "Registration", 
    "ICAOTypeCode", 
    "Manufacturer", 
    "Type", 
    "RegisteredOwners", 
    "OperatorFlagCode", 
    "UserNotes", 
    "SerialNo", 
    "YearBuilt"
)
SELECT 
    NULL, 
    CURRENT_TIMESTAMP, 
    CURRENT_TIMESTAMP, 
    O."ModeS", 
    O."Registration", 
    O."ICAOTypeCode", 
    O."Manufacturer", 
    O."Type", 
    O."RegisteredOwners", 
    O."OperatorFlagCode", 
    O."UserNotes", 
    O."SerialNo", 
    O."YearBuilt"
FROM OSkyData O
WHERE O."ModeS" NOT IN (SELECT "ModeS" FROM BasicAircraftPre);


-- Update YearBuilt and SerialNo in BasicAircraftPre using data from OSkyData for blank or NULL entries
UPDATE BasicAircraftPre
SET 
    "YearBuilt" = IFNULL(BasicAircraftPre."YearBuilt", O."YearBuilt"),
    "SerialNo" = IFNULL(BasicAircraftPre."SerialNo", O."SerialNo")
FROM OSkyData O
WHERE 
    BasicAircraftPre."ModeS" = O."ModeS";
	
