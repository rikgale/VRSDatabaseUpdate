UPDATE "FullAircraft"
SET "UserNotes" = CASE
    WHEN (SELECT "CorrectModeS" FROM "Miscode" WHERE "FullAircraft"."ModeS" = "Miscode"."Miscode") IS NOT NULL AND TRIM((SELECT "CorrectModeS" FROM "Miscode" WHERE "FullAircraft"."ModeS" = "Miscode"."Miscode")) <> ''
    THEN 'Miscode. ' || 'Correct ModeS code: ' || (SELECT "CorrectModeS" FROM "Miscode" WHERE "FullAircraft"."ModeS" = "Miscode"."Miscode") || ' ' || "UserNotes"
    ELSE 'Miscode. ' || "UserNotes"
END
WHERE "ModeS" IN (SELECT "Miscode" FROM "Miscode");
