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

