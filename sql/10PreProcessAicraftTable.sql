PRAGMA locking_mode=EXCLUSIVE;
PRAGMA busy_timeout=500000;

-- Reset the LastModified time using user tag RESET
UPDATE Aircraft
SET LastModified = FirstCreated,
    UserTag = NULL
WHERE UPPER(UserTag) = 'RESET';

-- Reset Last Modified time where Userstring1 equals missing, the ICAOType
-- is blank and firstcreated does not already equal last modified
UPDATE Aircraft
SET LastModified = FirstCreated,
    UserTag = NULL
WHERE UPPER(Userstring1) = 'MISSING'
    AND IFNULL(ICAOTypeCode, '') = ''
	AND LastModified <> FirstCreated;

-- Reset Last Mod time where OpFlag contains listed, is 3 chars long
-- and only for specific aircraft types
UPDATE "Aircraft"
SET "LastModified" = "FirstCreated"
WHERE ("OperatorFlagCode" IN ('BLANK', 'BLANK1', 'BLANK2')
       OR LENGTH("OperatorFlagCode") = 3)
  AND "FirstCreated" <> "LastModified"
  AND "ICAOTypeCode" IN ('E170', 'E190', 'E195', 'E295', 'A19N', 'A20N', 'A21N', 'A318', 'A319', 'A320', 'A321', 'A337', 'A339', 'A359', 'A35K', 'B734', 'B733', 'B735', 'B736', 'B737', 'B738', 'B739', 'B37M', 'B38M', 'B39M', 'B3XM', 'B752', 'B753', 'B762', 'B763', 'B764', 'B772', 'B773', 'B77L', 'B77W', 'B788', 'B789', 'B78X', 'BCS1', 'BCS3');


-- Delete rows from Aircraft table that are 'missing', have no
--  ICAOTypeCode and not from today (to avoid deleting active entry)
DELETE FROM "Aircraft"
WHERE "AircraftID" NOT IN (SELECT DISTINCT "AircraftID" FROM "Flights")
    AND UPPER("UserString1") = 'MISSING'
    AND IFNULL("ICAOTypeCode", '') = ''
    AND SUBSTR("FirstCreated", 1, 10) <> DATE('now', 'localtime');
