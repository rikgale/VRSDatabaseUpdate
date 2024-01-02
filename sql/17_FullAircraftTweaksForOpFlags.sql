/* UK Air Ambulance, Police and HMCG Tweaks */

UPDATE FullAircraft
SET OperatorFlagCode = 'HLE-' || ICAOTypeCode || Registration
WHERE RegisteredOwners LIKE '%Air Ambulance%'
    AND Registration LIKE 'G-%';

UPDATE FullAircraft
SET OperatorFlagCode = 'HLE-' || ICAOTypeCode || Registration
WHERE OperatorFlagCode = 'PLC';

UPDATE FullAircraft
SET OperatorFlagCode = 
  CASE
    WHEN Registration = 'G-POLS' THEN 'UKP-' || ICAOTypeCode
    ELSE 'HLE-' || ICAOTypeCode || Registration
  END
WHERE OperatorFlagCode = 'RHD';

UPDATE FullAircraft
SET OperatorFlagCode = 
  CASE 
    WHEN RegisteredOwners NOT LIKE '%Ireland%' THEN 'UKP-' || ICAOTypeCode
    WHEN RegisteredOwners LIKE '%Ireland%' THEN 'UKP-' || ICAOTypeCode || 'PSNO'
  END
WHERE OperatorFlagCode = 'UKP';

UPDATE FullAircraft
SET OperatorFlagCode = 'SRD-' || ICAOTypeCode
WHERE OperatorFlagCode = 'SRD';

UPDATE FullAircraft
SET OperatorFlagCode = 
  CASE
    WHEN OperatorFlagCode = 'GEN-S92' AND RegisteredOwners LIKE 'Irish Coastguard' THEN 'IRLCG-S92'
    ELSE OperatorFlagCode
  END;

/* US Military Tweaks */

UPDATE FullAircraft
SET OperatorFlagCode = 
  CASE
    WHEN OperatorFlagCode = 'PAT-EC45' AND Type LIKE '%UH-72A%' THEN 'PAT-UH72'
    WHEN OperatorFlagCode = 'PAT-EC45' AND Type LIKE '%UH-72B%' THEN 'PAT-UH72B'
	WHEN OperatorFlagCode = 'PAT-BE20' AND Type LIKE '%RC-12X%' THEN 'PAT-RC12'
	WHEN OperatorFlagCode = 'PAT-BE20' AND Type LIKE '%MC-12%' THEN 'PAT-MC12'
    WHEN OperatorFlagCode = 'PAT-BE20' AND Type LIKE '%C-12%' THEN 'PAT-C12U'
	WHEN OperatorFlagCode = 'PAT-GLF5' AND Type LIKE '%C-37%' THEN 'PAT-C37A'
	WHEN OperatorFlagCode = 'CNV-P8' THEN 'CNV-P8A'
	WHEN OperatorFlagCode = 'RCH-K35R' THEN 'RCH-KC135BOOM'
	WHEN OperatorFlagCode = 'RCH-B762' THEN 'RCH-KC46BOOM'
	WHEN OperatorFlagCode = 'RCH-DC10' THEN 'RCH-KC10BOOM'
	WHEN OperatorFlagCode = 'RCH-BE40' THEN 'RCH-T1'
	WHEN OperatorFlagCode = 'RCH-LJ35' THEN 'RCH-C21A'
	WHEN OperatorFlagCode = 'RCH-PC12' THEN 'RCH-U28'
	WHEN OperatorFlagCode = 'RCH-SR20' THEN 'RCH-T53'
	WHEN OperatorFlagCode = 'RCH-C172' THEN 'RCH-T41'
	WHEN OperatorFlagCode = 'RCH-DH8A' THEN 'RCH-E9A'
	WHEN OperatorFlagCode = 'RCH-DH8B' THEN 'RCH-E9A'
	WHEN OperatorFlagCode = 'RCH-DHC6' THEN 'RCH-UV18'
	WHEN OperatorFlagCode = 'RCH-GLF5' AND Type LIKE '%C-37A%' THEN 'RCH-C37A'
	WHEN OperatorFlagCode = 'RCH-GLF5' AND Type LIKE '%C-37B%' THEN 'RCH-C37B'
	WHEN OperatorFlagCode = 'RCH-GLEX' AND Type LIKE '%E-11%' THEN 'RCH-E11'
	WHEN OperatorFlagCode = 'RCH-B212' AND Type LIKE '%UH-1N%' THEN 'RCH-UH1'
	WHEN OperatorFlagCode = 'RCH-R135' AND Type LIKE '%135S%' THEN 'RCH-R135S'
	WHEN OperatorFlagCode = 'RCH-R135' AND Type LIKE '%135U%' THEN 'RCH-R135U'
	WHEN OperatorFlagCode = 'RCH-R135' AND Type LIKE '%RC-135W%' THEN 'RCH-R135W'
	WHEN OperatorFlagCode = 'RCH-R135' AND Type LIKE '%TC-135W%' THEN 'RCH-TC135W'
	WHEN OperatorFlagCode = 'RCH-R135' AND Type LIKE '%135V%' THEN 'RCH-R135V'
	WHEN OperatorFlagCode = 'PAT-B350' AND Type LIKE '%MC-12%' THEN 'RCH-MC12'
	WHEN OperatorFlagCode = 'RCH-BE20' AND Type LIKE '%C-12%' THEN 'RCH-C12D'
	WHEN OperatorFlagCode = 'RCH-B190' AND Type LIKE '%C-12J%' THEN 'RCH-C12J'
	WHEN OperatorFlagCode = 'CNV-BE9L' THEN 'CNV-T44'
	WHEN OperatorFlagCode = 'CNV-BE20' THEN 'CNV-UC12'
	WHEN OperatorFlagCode = 'CNV-GLF5' AND Type LIKE '%C-37%' THEN 'CNV-C37B'
	WHEN OperatorFlagCode = 'CNV-ASTR' AND Type LIKE '%C-38%' THEN 'CNV-C38'
	WHEN OperatorFlagCode = 'CNV-GLF4' AND Type LIKE '%C-20%' THEN 'CNV-C20G'
    ELSE OperatorFlagCode
  END;

UPDATE FullAircraft
SET ICAOTypeCode = 'BT7'
WHERE Type LIKE '%T-7 Red%';

UPDATE FullAircraft
SET OperatorFlagCode = 'RCH-' || ICAOTypeCode
WHERE ICAOTypeCode = 'BT7' AND OperatorFlagCode LIKE 'RCH-%';

/* French Tweaks */

UPDATE FullAircraft
SET OperatorFlagCode = 'FRU-' || ICAOTypeCode
WHERE OperatorFlagCode = 'FRU' AND UserNotes NOT LIKE '%Miscode%';

/* Civil Operators Tweaks */

-- FlyArystan as part of Air Astana
UPDATE FullAircraft
SET OperatorFlagCode = 'KZR-' || ICAOTypeCode || 'FA'
WHERE RegisteredOwners = 'FlyArystan'
  AND SUBSTR(OperatorFlagCode, 1, 3) = 'KZR';

-- Correction for PlaneBase listing some CC-xxx as LATAM Columbia rather than LATAM Airlines Chilie
UPDATE FullAircraft
SET OperatorFlagCode = 'LAN-' || ICAOTypeCode,
    RegisteredOwners = 'LATAM Airlines Chile'
WHERE Registration LIKE 'CC-%' AND RegisteredOwners = 'LATAM Colombia';



  
 
