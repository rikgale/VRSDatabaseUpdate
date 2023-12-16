UPDATE JPAircraft
SET
  ICAOTypeCode = (
    SELECT NewICAOTypeCode
    FROM ICAOTypeConversion
    WHERE ICAOTypeConversion.OldICAOTypeCode = JPAircraft.ICAOTypeCode
  ),
  OperatorFlagCode = REPLACE(
    OperatorFlagCode,
    (
      SELECT OldICAOTypeCode
      FROM ICAOTypeConversion
      WHERE ICAOTypeConversion.OldICAOTypeCode = JPAircraft.ICAOTypeCode
    ),
    (
      SELECT NewICAOTypeCode
      FROM ICAOTypeConversion
      WHERE ICAOTypeConversion.OldICAOTypeCode = JPAircraft.ICAOTypeCode
    )
  )
WHERE ICAOTypeCode IN (SELECT OldICAOTypeCode FROM ICAOTypeConversion);

UPDATE BJAircraft
SET
  ICAOTypeCode = (
    SELECT NewICAOTypeCode
    FROM ICAOTypeConversion
    WHERE ICAOTypeConversion.OldICAOTypeCode = BJAircraft.ICAOTypeCode
  ),
  OperatorFlagCode = REPLACE(
    OperatorFlagCode,
    (
      SELECT OldICAOTypeCode
      FROM ICAOTypeConversion
      WHERE ICAOTypeConversion.OldICAOTypeCode = BJAircraft.ICAOTypeCode
    ),
    (
      SELECT NewICAOTypeCode
      FROM ICAOTypeConversion
      WHERE ICAOTypeConversion.OldICAOTypeCode = BJAircraft.ICAOTypeCode
    )
  )
WHERE ICAOTypeCode IN (SELECT OldICAOTypeCode FROM ICAOTypeConversion);
