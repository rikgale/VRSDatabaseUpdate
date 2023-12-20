-- Create indexes on the ModeS and ICAOTypeCode columns
CREATE INDEX idx_ModeS_ICAOTypeCode_FullAircraft ON FullAircraft(ModeS, ICAOTypeCode);
CREATE INDEX idx_ModeS_ICAOTypeCode_OSkyData ON OSkyData(ModeS, ICAOTypeCode);

UPDATE FullAircraft
SET YearBuilt = (
    SELECT OSkyData.YearBuilt
    FROM OSkyData
    WHERE FullAircraft.ModeS = OSkyData.ModeS AND FullAircraft.ICAOTypeCode = OSkyData.ICAOTypeCode
        AND OSkyData.YearBuilt IS NOT NULL AND OSkyData.YearBuilt != ''
)
WHERE EXISTS (
    SELECT 1
    FROM OSkyData
    WHERE FullAircraft.ModeS = OSkyData.ModeS AND FullAircraft.ICAOTypeCode = OSkyData.ICAOTypeCode
        AND OSkyData.YearBuilt IS NOT NULL AND OSkyData.YearBuilt != ''
);
