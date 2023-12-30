/* 

-- Add a new column called Registration
ALTER TABLE OperatorFlags ADD COLUMN Registration VARCHAR(20);

-- Update the new Registration column with the processed data
UPDATE OperatorFlags
SET Registration = REPLACE(Name, '.bmp', '');

-- Remove entries less than 10 characters
DELETE FROM OperatorFlags
WHERE LENGTH(Registration) < 10;

-- Remove the first 10 characters
UPDATE OperatorFlags
SET Registration = SUBSTR(Registration, 9);

-- Delete rows that don't start with 'N', don't contain '-', or start with '-'
DELETE FROM OperatorFlags
WHERE NOT (Registration LIKE 'N%' OR Registration LIKE '%-%') OR Registration LIKE '-%';

-- Delete rows that are 4 or fewer characters long
DELETE FROM OperatorFlags
WHERE LENGTH(Registration) <= 4;

-- Delete rows that are 7 or more characters long
DELETE FROM OperatorFlags
WHERE LENGTH(Registration) >= 7;

-- Copy last 6 characters for registrations starting with 'Q' 
UPDATE OperatorFlags 
SET Registration = SUBSTR(Name, -6) 
WHERE Registration LIKE 'Q%';

*/

/* NEW PROCESS - Extracts more registrations */
 
-- Add a new column called Registration
ALTER TABLE OperatorFlags ADD COLUMN Registration VARCHAR(20);

-- Update the new Registration column with the processed data
UPDATE OperatorFlags
SET Registration = REPLACE(Name, '.bmp', '');

-- Remove entries less than 10 characters
DELETE FROM OperatorFlags
WHERE LENGTH(Registration) < 10;

-- Update the Registration column to keep only the last 6 characters
UPDATE OperatorFlags
SET Registration = SUBSTR(Registration, -6);

DELETE FROM OperatorFlags
WHERE Registration LIKE 'R-%' 
    OR Name LIKE '%ZZZZ%'
	OR Registration LIKE 'ZZ-%' 
	OR Registration LIKE 'Y-%'
	OR Registration LIKE 'A-%'
	OR Registration LIKE '%-BE20'
	OR Registration LIKE '%-P180'
	OR Registration LIKE '%-A3%'
	OR Registration LIKE 'NGEC35'
	OR Registration LIKE '%-MD87'
	OR Registration LIKE 'N26UNO'
	OR Registration LIKE 'NELJ35'
	OR Registration LIKE '%-SW4'
	OR Registration LIKE '%-F100'
	OR Registration LIKE '%-E120'
	OR Registration LIKE '%-DH8%'
	OR Registration LIKE '%-DHC%'
	OR Registration LIKE '%-SF34'
	OR Registration LIKE '%-EV97'
	OR Registration LIKE '%-A123'
	OR Registration LIKE '%-IL76'
	OR Registration LIKE '%-B73%'
	OR Registration LIKE '%-A319'
	OR Registration LIKE '%-SC7'
	OR Registration LIKE '%-MG15'
	OR Registration LIKE '%-E35L'
	OR Registration LIKE '%-M339'
	OR Registration LIKE '%-GLF%'
	OR Registration LIKE '%-E767'
	OR Registration LIKE '%-C130'
	OR Registration LIKE '%-C68A'
	OR Registration LIKE '%-B762'
	OR Registration LIKE '%-B74%'
	OR Registration LIKE '%-B77%'
	OR Registration LIKE '%-B78%'
	OR Registration LIKE '%-CRJ%'
	OR Registration LIKE '%-SU95'
	OR Registration LIKE '%-AT76'
	OR Registration LIKE '%-E190'
	OR Registration LIKE '%-H47'
	OR Registration LIKE '%-EC55'
	OR Registration LIKE '%-C30J'
	OR NOT (
          (Registration LIKE 'N%' AND Registration GLOB '*[0-9]*') OR
          Registration LIKE '%-%' OR
          Registration LIKE 'JA%'
      ) OR Registration LIKE '-%';
	  
UPDATE OperatorFlags
SET Name = REPLACE(Name, '.bmp', '');


UPDATE OperatorFlags
SET Registration = 
    CASE
        WHEN Registration LIKE '7-%' THEN SUBSTR(Name, -7)
        WHEN Registration LIKE 'H-%' THEN SUBSTR(Name, -7)
		    WHEN Registration LIKE 'Z-%' THEN SUBSTR(Name, -7)
		    WHEN Registration LIKE 'J-%' THEN SUBSTR(Name, -7)
		    WHEN Registration LIKE 'U-%' THEN SUBSTR(Name, -7)
		    WHEN Registration LIKE 'K-%' THEN SUBSTR(Name, -7)
		    WHEN Registration LIKE 'BHZ-%' THEN SUBSTR(Name, -5)
	    	WHEN Registration LIKE '6FA-87' THEN SUBSTR(Name, -5)
		    WHEN Registration LIKE '3B-HNK' THEN SUBSTR(Name, -5)
        WHEN Registration LIKE '1B-%' THEN SUBSTR(Name, -5)
        ELSE Registration
    END;
