PRAGMA locking_mode=EXCLUSIVE;
PRAGMA busy_timeout=500000;

-- Drop and recreate triggers in BaseStation.sqb

-- Drop GAFEUFI trigger
DROP TRIGGER IF EXISTS GAFEUFI;
-- Recreate GAFEUFI trigger
CREATE TRIGGER GAFEUFI
  AFTER UPDATE
  ON Aircraft
BEGIN
  UPDATE Aircraft
  SET Manufacturer = 'Eurofighter',
      Type = 'Eurofighter Typhoon EF2000',
      OperatorFlagCode = 'GAF-EUFI',
      RegisteredOwners = 'German Air Force',
	  UserBool1 = '1',
	  UserString1 = NULL
  WHERE OperatorFlagCode = 'GAF'
  AND ICAOTypeCode = 'EUFI'
  AND AircraftID = NEW.AircraftID;
END;

-- Drop GAFSTALLION trigger
DROP TRIGGER IF EXISTS GAFSTALLION;
-- Recreate GAFSTALLION trigger
CREATE TRIGGER GAFSTALLION
  AFTER UPDATE
  ON Aircraft
BEGIN
  UPDATE Aircraft
  SET Manufacturer = 'Sikorsky',
      Type = 'Sikorsky CH-53G',
      OperatorFlagCode = 'GAF-H53',
      RegisteredOwners = 'German Air Force',
	  UserBool1 = '1',
	  UserString1 = NULL
  WHERE OperatorFlagCode = 'GAF'
  AND ICAOTypeCode = 'H53'
  AND AircraftID = NEW.AircraftID;
END;

-- Drop GAFTORNADO trigger
DROP TRIGGER IF EXISTS GAFTORNADO;
-- Recreate GAFTORNADO trigger
CREATE TRIGGER GAFTORNADO
  AFTER UPDATE
  ON Aircraft
BEGIN
  UPDATE Aircraft
  SET Manufacturer = 'Panavia',
      Type = 'Panavia Tornado',
      OperatorFlagCode = 'GAF-TOR',
      RegisteredOwners = 'German Air Force',
	  UserBool1 = '1',
	  UserString1 = NULL
  WHERE OperatorFlagCode = 'GAF'
  AND ICAOTypeCode = 'TOR'
  AND AircraftID = NEW.AircraftID;
END;

-- Drop P8Poseidon trigger
DROP TRIGGER IF EXISTS P8Poseidon;
-- Recreate P8Poseidon trigger
CREATE TRIGGER P8Poseidon
  AFTER UPDATE
  ON Aircraft
BEGIN
  UPDATE Aircraft
  SET Manufacturer = 'Boeing',
      Type = 'Boeing P-8A Poseidon',
      OperatorFlagCode = 'CNV-P8A',
      RegisteredOwners = 'United States Navy',
	  UserBool1 = '1',
	  UserString1 = NULL
  WHERE OperatorFlagCode = 'CNV'
  AND ICAOTypeCode = 'P8'
  AND AircraftID = NEW.AircraftID;
END;

-- Drop GAFEC45 trigger
DROP TRIGGER IF EXISTS GAFEC45;
-- Recreate GAFEC45 trigger
CREATE TRIGGER GAFEC45
  AFTER UPDATE
  ON Aircraft
BEGIN
  UPDATE Aircraft
  SET Manufacturer = 'Airbus Helicopters',
      Type = 'Airbus Helicopters H-145M',
      OperatorFlagCode = 'GAF-EC45',
      RegisteredOwners = 'German Air Force',
	  UserBool1 = '1',
	  UserString1 = NULL
  WHERE OperatorFlagCode = 'GAF'
  AND ICAOTypeCode = 'EC45'
  AND AircraftID = NEW.AircraftID;
END;

-- Drop USMCV22 trigger
DROP TRIGGER IF EXISTS USMCV22;
-- Recreate USMCV22 trigger
CREATE TRIGGER USMCV22
  AFTER UPDATE
  ON Aircraft
BEGIN
  UPDATE Aircraft
  SET Manufacturer = 'Bell/Boeing',
      Type = 'Bell/Boeing MV-22B Osprey',
      OperatorFlagCode = 'USMC-V22',
      RegisteredOwners = 'United States Marine Corps',
	  UserBool1 = '1',
	  UserString1 = NULL
  WHERE OperatorFlagCode = 'USMC'
  AND ICAOTypeCode = 'V22'
  AND AircraftID = NEW.AircraftID;
END;

-- Drop SetManufacturer trigger
DROP TRIGGER IF EXISTS SetManufacturer;
-- Recreate SetManufacturer trigger
CREATE TRIGGER SetManufacturer
  AFTER UPDATE
  ON Aircraft
BEGIN
  UPDATE Aircraft
  SET Manufacturer = 'Sikorsky'
  WHERE ICAOTypeCode = 'H60'
  AND AircraftID = NEW.AircraftID;
END;