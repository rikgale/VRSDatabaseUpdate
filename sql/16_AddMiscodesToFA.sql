INSERT OR IGNORE INTO "FullAircraft" (
    "ModeS",
    "UserNotes",
    "ICAOTypeCode",
    "Type",
    "RegisteredOwners",
    "OperatorFlagCode",
    "SerialNo",
    "YearBuilt",
    "Registration",
    "FirstCreated",
    "LastModified"
)
SELECT
    "Miscode"."Miscode",
    "Miscode"."UserNotes",
    "Miscode"."ICAOTypeCode",
    "Miscode"."Type",
    "Miscode"."RegisteredOwners",
    "Miscode"."OperatorFlagCode",
    "Miscode"."SerialNo",
    "Miscode"."YearBuilt",
    "Miscode"."Registration",
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM "Miscode"
WHERE "Miscode"."Miscode" IS NOT NULL
    AND "Miscode"."Miscode" NOT IN (SELECT "ModeS" FROM "FullAircraft");
