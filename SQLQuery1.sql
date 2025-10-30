USE JOSEPH ;
GO

-- checking the structure of the table 
EXEC sp_help 'patients';
GO

--- preview the first 10 row
SELECT DISTINCT TOP 10 *
FROM patients ;
GO 
--Checking columns that has null values
SELECT
  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS missing_name,
  SUM(CASE WHEN service IS NULL THEN 1 ELSE 0 END) AS missing_service,
  SUM(CASE WHEN satisfaction IS NULL THEN 1 ELSE 0 END) AS missing_satisfaction
FROM patients;
GO

-- checking for duplicates 
SELECT name , COUNT(*) AS total
FROM patients
GROUP BY name
HAVING COUNT(*) >1;
GO

--delete duplicates
DELETE FROM patients
WHERE patient_id NOT IN (
  SELECT MIN(patient_id)
  FROM patients
  GROUP BY name, service, satisfaction
);
GO
-- checking if my duplicates deletion worked
SELECT 
  name, 
  service, 
  satisfaction,
  COUNT(*) AS record_count
FROM patients
GROUP BY name, service, satisfaction
HAVING COUNT(*) > 1;
GO

---- Trim extra spaces and convert to lowercase
UPDATE patients
SET service = LOWER(LTRIM(RTRIM(service)));
GO
--check for invalid satifaction score
SELECT *
FROM patients
WHERE satisfaction <0 OR satisfaction >100;
GO
--- check and validate result
SELECT 
  COUNT(*) AS total_rows,
  COUNT(DISTINCT patient_id) AS unique_patients
  FROM patients;
  GO
  -- checking for the distribution of the data
  SELECT service, COUNT(*) AS total_patients
  FROM patients
  GROUP BY service
  ORDER BY total_patients DESC;
  GO
  ---new table
  SELECT *
INTO patient_cleaned_IT
FROM patients;
  GO

  SELECT TOP 10 *
  FROM patient_cleaned_IT;

