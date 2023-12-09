-- Update existing data in MilICAOOperatorLookup to set blank cells to NULL
UPDATE MilICAOOperatorLookup
SET RegisteredOwner = CASE WHEN RegisteredOwner = '' THEN NULL ELSE RegisteredOwner END,
    ICAOOperatorCode = CASE WHEN ICAOOperatorCode = '' THEN NULL ELSE ICAOOperatorCode END;

