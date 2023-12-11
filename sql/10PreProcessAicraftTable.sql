PRAGMA locking_mode=EXCLUSIVE;
PRAGMA busy_timeout=500000;


UPDATE Aircraft
SET LastModified = FirstCreated,
    UserTag = NULL
WHERE UPPER(UserTag) = 'RESET';

UPDATE "Aircraft"
SET "LastModified" = "FirstCreated"
WHERE ("OperatorFlagCode" IN ('BLANK', 'BLANK1', 'BLANK2')
       OR LENGTH("OperatorFlagCode") = 3)
  AND "FirstCreated" <> "LastModified"
  AND "ICAOTypeCode" IN ('E170', 'E190', 'E195', 'E295', 'A19N', 'A20N', 'A21N', 'A318', 'A319', 'A320', 'A321', 'A337', 'A339', 'A359', 'A35K', 'B734', 'B733', 'B735', 'B736', 'B737', 'B738', 'B739', 'B37M', 'B38M', 'B39M', 'B3XM', 'B752', 'B753', 'B762', 'B763', 'B764', 'B772', 'B773', 'B77L', 'B77W', 'B788', 'B789', 'B78X', 'BCS1', 'BCS3');
