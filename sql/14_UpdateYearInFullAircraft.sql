-- Create indexes on the ModeS and ICAOTypeCode columns for efficient data retrieval
CREATE INDEX idx_ModeS_ICAOTypeCode_FullAircraft ON FullAircraft(ModeS, ICAOTypeCode);
CREATE INDEX idx_ModeS_ICAOTypeCode_Year ON Year(ModeS, ICAOTypeCode);

-- Update FullAircraft table with YearBuilt values from Year table where applicable
UPDATE FullAircraft
SET YearBuilt = (
    SELECT Year.YearBuilt
    FROM Year
    WHERE FullAircraft.ModeS = Year.ModeS AND FullAircraft.ICAOTypeCode = Year.ICAOTypeCode
        AND Year.YearBuilt IS NOT NULL AND Year.YearBuilt != ''
)
WHERE EXISTS (
    SELECT 1
    FROM Year
    WHERE FullAircraft.ModeS = Year.ModeS AND FullAircraft.ICAOTypeCode = Year.ICAOTypeCode
);

-- Set YearBuilt to NULL for values that are either invalid or pre-1908
-- Invalid values include those with a length not equal to 4 or containing non-numeric characters
UPDATE FullAircraft
SET YearBuilt = NULL
WHERE LENGTH(REPLACE(YearBuilt, '?', '')) != 4 OR
      (LENGTH(REPLACE(YearBuilt, '?', '')) = 4 AND CAST(REPLACE(YearBuilt, '?', '') AS INTEGER) < 1908);

