
UPDATE BJAircraft
SET OperatorFlagCode = 
    IIF(MilICAOOperatorLookup.ICAOOperatorCode IS NOT NULL, 
        MilICAOOperatorLookup.ICAOOperatorCode || '-' || BJAircraft.ICAOTypeCode, 
        OperatorFlagCode)
FROM MilICAOOperatorLookup
WHERE BJAircraft.RegisteredOwners = IFNULL(MilICAOOperatorLookup.RegisteredOwner, '') OR IFNULL(MilICAOOperatorLookup.RegisteredOwner, '') = '';


UPDATE BJAircraft
SET OperatorFlagCode = CASE
    WHEN IFNULL(OperatorFlagCode, '') = '' THEN 'GEN-' || ICAOTypeCode
    ELSE OperatorFlagCode
END;


UPDATE JPAircraft
SET OperatorFlagCode = IIF(MilICAOOperatorLookup.ICAOOperatorCode IS NOT NULL, 
                          MilICAOOperatorLookup.ICAOOperatorCode || '-' || JPAircraft.ICAOTypeCode, 
                          OperatorFlagCode)
FROM MilICAOOperatorLookup
WHERE JPAircraft.RegisteredOwners = IFNULL(MilICAOOperatorLookup.RegisteredOwner, '') OR IFNULL(MilICAOOperatorLookup.RegisteredOwner, '') = '';


UPDATE JPAircraft
SET OperatorFlagCode = IIF(LENGTH(OperatorFlagCode) <= 4 AND INSTR(OperatorFlagCode, '-') = 0,
                          'GEN-' || ICAOTypeCode,
                          IIF(LENGTH(OperatorFlagCode) >= 5 AND INSTR(OperatorFlagCode, '-') = 0,
                              SUBSTR(OperatorFlagCode, 1, 3) || '-' || SUBSTR(OperatorFlagCode, 4),
                              OperatorFlagCode)
                         );









