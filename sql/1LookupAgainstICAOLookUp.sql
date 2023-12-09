UPDATE BJAircraft
SET ICAOTypeCode = (
    SELECT NewICAOTypeCode
    FROM ICAOTypeConversion
    WHERE ICAOTypeConversion.OldICAOTypeCode = BJAircraft.ICAOTypeCode
)
WHERE ICAOTypeCode IN (SELECT OldICAOTypeCode FROM ICAOTypeConversion);

UPDATE JPAircraft
SET ICAOTypeCode = (
    SELECT NewICAOTypeCode
    FROM ICAOTypeConversion
    WHERE ICAOTypeConversion.OldICAOTypeCode = JPAircraft.ICAOTypeCode
)
WHERE ICAOTypeCode IN (SELECT OldICAOTypeCode FROM ICAOTypeConversion);


