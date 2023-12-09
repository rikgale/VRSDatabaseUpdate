CREATE TABLE IF NOT EXISTS PBAircraft AS
SELECT
  ROW_NUMBER() OVER (ORDER BY ModeS) AS AircraftID,
  FirstCreated,
  LastModified,
  ModeS,
  ModeSCountry,
  Country,
  Registration,
  CurrentRegDate,
  PreviousID,
  FirstRegDate,
  Status,
  DeRegDate,
  Manufacturer,
  ICAOTypeCode,
  Type,
  SerialNo,
  PopularName,
  GenericName,
  AircraftClass,
  Engines,
  OwnershipStatus,
  RegisteredOwners,
  MTOW,
  TotalHours,
  YearBuilt,
  CofACategory,
  CofAExpiry,
  UserNotes,
  Interested,
  UserTag,
  InfoURL,
  PictureURL1,
  PictureURL2,
  PictureURL3,
  UserBool1,
  UserBool2,
  UserBool3,
  UserBool4,
  UserBool5,
  UserString1,
  UserString2,
  UserString3,
  UserString4,
  UserString5,
  UserInt1,
  UserInt2,
  UserInt3,
  UserInt4,
  UserInt5,
  OperatorFlagCode
FROM (
  SELECT * FROM BJAircraft
  UNION
  SELECT * FROM JPAircraft
) AS CombinedAircraft
GROUP BY ModeS;

UPDATE PBAircraft
SET UserNotes = 'Updated S1: ' || datetime('now')
WHERE UserNotes IS NULL OR TRIM(UserNotes) = '';

