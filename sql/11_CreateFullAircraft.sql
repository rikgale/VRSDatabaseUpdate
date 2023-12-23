-- Create FullAircraft table with sequential AircraftID
CREATE TABLE IF NOT EXISTS FullAircraft (
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

-- Copy from PBAircraft to FullAircraft where ModeS does not exist in FullAircraft
INSERT INTO FullAircraft (
    FirstCreated, LastModified, ModeS, ModeSCountry, Country, Registration,
    CurrentRegDate, PreviousID, FirstRegDate, Status, DeRegDate, Manufacturer,
    ICAOTypeCode, Type, SerialNo, PopularName, GenericName, AircraftClass,
    Engines, OwnershipStatus, RegisteredOwners, MTOW, TotalHours, YearBuilt,
    CofACategory, CofAExpiry, UserNotes, Interested, UserTag, InfoURL,
    PictureURL1, PictureURL2, PictureURL3, UserBool1, UserBool2, UserBool3,
    UserBool4, UserBool5, UserString1, UserString2, UserString3, UserString4,
    UserString5, UserInt1, UserInt2, UserInt3, UserInt4, UserInt5,
    OperatorFlagCode
)
SELECT 
    FirstCreated, LastModified, ModeS, ModeSCountry, Country, Registration,
    CurrentRegDate, PreviousID, FirstRegDate, Status, DeRegDate, Manufacturer,
    ICAOTypeCode, Type, SerialNo, PopularName, GenericName, AircraftClass,
    Engines, OwnershipStatus, RegisteredOwners, MTOW, TotalHours, YearBuilt,
    CofACategory, CofAExpiry, UserNotes, Interested, UserTag, InfoURL,
    PictureURL1, PictureURL2, PictureURL3, UserBool1, UserBool2, UserBool3,
    UserBool4, UserBool5, UserString1, UserString2, UserString3, UserString4,
    UserString5, UserInt1, UserInt2, UserInt3, UserInt4, UserInt5,
    OperatorFlagCode
FROM PBAircraft
WHERE ModeS NOT IN (SELECT ModeS FROM FullAircraft);

-- Copy from BasicAircraftPre to FullAircraft where ModeS does not exist in FullAircraft
INSERT INTO FullAircraft (
    FirstCreated, LastModified, ModeS, ModeSCountry, Country, Registration,
    CurrentRegDate, PreviousID, FirstRegDate, Status, DeRegDate, Manufacturer,
    ICAOTypeCode, Type, SerialNo, PopularName, GenericName, AircraftClass,
    Engines, OwnershipStatus, RegisteredOwners, MTOW, TotalHours, YearBuilt,
    CofACategory, CofAExpiry, UserNotes, Interested, UserTag, InfoURL,
    PictureURL1, PictureURL2, PictureURL3, UserBool1, UserBool2, UserBool3,
    UserBool4, UserBool5, UserString1, UserString2, UserString3, UserString4,
    UserString5, UserInt1, UserInt2, UserInt3, UserInt4, UserInt5,
    OperatorFlagCode
)
SELECT 
    FirstCreated, LastModified, ModeS, ModeSCountry, Country, Registration,
    CurrentRegDate, PreviousID, FirstRegDate, Status, DeRegDate, Manufacturer,
    ICAOTypeCode, Type, SerialNo, PopularName, GenericName, AircraftClass,
    Engines, OwnershipStatus, RegisteredOwners, MTOW, TotalHours, YearBuilt,
    CofACategory, CofAExpiry, UserNotes, Interested, UserTag, InfoURL,
    PictureURL1, PictureURL2, PictureURL3, UserBool1, UserBool2, UserBool3,
    UserBool4, UserBool5, UserString1, UserString2, UserString3, UserString4,
    UserString5, UserInt1, UserInt2, UserInt3, UserInt4, UserInt5,
    OperatorFlagCode
FROM BasicAircraftPre
WHERE ModeS NOT IN (SELECT ModeS FROM FullAircraft);
