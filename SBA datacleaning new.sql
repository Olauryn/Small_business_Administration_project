--DATA CLEANING PROCESS
SELECT TOP (1000) [NAICS_Codes]
      ,[NAICS_Industry_Description]
  FROM [Portfolio_projectsDB].[dbo].[industry_standards];
---
SELECT [NAICS_Industry_Description],
SUBSTRING([NAICS_Industry_Description], 8, 2) AS lookup_codes
  FROM [Portfolio_projectsDB].[dbo].[industry_standards]
  WHERE [NAICS_Codes]= '';
--
SELECT [NAICS_Industry_Description],
		IIF([NAICS_Industry_Description] LIKE '%–%', SUBSTRING([NAICS_Industry_Description], 8, 2), '') AS lookup_codes
  FROM [Portfolio_projectsDB].[dbo].[industry_standards]
  WHERE [NAICS_Codes]= ''

  SELECT [NAICS_Industry_Description],
		IIF([NAICS_Industry_Description] LIKE '%–%', SUBSTRING([NAICS_Industry_Description], 8, 2), '') AS lookup_codes,
		--CASE WHEN [NAICS_Industry_Description] LIKE '%–%' THEN SUBSTRING([NAICS_Industry_Description], 8, 2) END AS lookupCodes_case--
  FROM [Portfolio_projectsDB].[dbo].[industry_standards]
  WHERE [NAICS_Codes]= '';



  -----------------------
  SELECT *
  FROM		(
			SELECT [NAICS_Industry_Description],
			IIF([NAICS_Industry_Description] LIKE '%–%', SUBSTRING([NAICS_Industry_Description], 8, 2), '') AS lookup_codes
			FROM [Portfolio_projectsDB].[dbo].[industry_standards]
			WHERE [NAICS_Codes]= ''
  )AS main
  WHERE lookup_codes != '';

--------------------------------------
SELECT *
 FROM		(
			SELECT [NAICS_Industry_Description],
			IIF([NAICS_Industry_Description] LIKE '%–%', SUBSTRING([NAICS_Industry_Description], 8, 2), '') AS lookup_codes,
			SUBSTRING([NAICS_Industry_Description], CHARINDEX('–',[NAICS_Industry_Description]) +1 , LEN([NAICS_Industry_Description])) AS Sector
			FROM [Portfolio_projectsDB].[dbo].[industry_standards]
			WHERE [NAICS_Codes]= ''
  )AS main
 WHERE lookup_codes != '';

--To remove white space from the begining of the sector column
SELECT *
  FROM		(
			SELECT [NAICS_Industry_Description],
			IIF([NAICS_Industry_Description] LIKE '%–%', SUBSTRING([NAICS_Industry_Description], 8, 2), '') AS lookup_codes,
		LTRIM(SUBSTRING([NAICS_Industry_Description], CHARINDEX('–',[NAICS_Industry_Description]) +1 , LEN([NAICS_Industry_Description]))) AS Sector
			FROM [Portfolio_projectsDB].[dbo].[industry_standards]
			WHERE [NAICS_Codes]= ''
  )AS main
  WHERE lookup_codes != '';

--To put the query result into a table 
SELECT *
INTO sba_naics_sector_codes_description
FROM		(
			SELECT [NAICS_Industry_Description],
			       IIF([NAICS_Industry_Description] LIKE '%–%', SUBSTRING([NAICS_Industry_Description], 8, 2), '') AS lookup_codes,
		           LTRIM(SUBSTRING([NAICS_Industry_Description], CHARINDEX('–',[NAICS_Industry_Description]) +1 , LEN([NAICS_Industry_Description]))) AS Sector
			FROM [Portfolio_projectsDB].[dbo].[industry_standards]
			WHERE [NAICS_Codes]= ''
  )AS main
  WHERE lookup_codes != '';

---SELECT the table naics codes description
SELECT TOP (1000) [NAICS_Industry_Description]
      ,[lookup_codes]
      ,[Sector]
  FROM [Portfolio_projectsDB].[dbo].[sba_naics_sector_codes_description]
  ORDER BY lookup_codes;


--to insert the value of 32, 33 
INSERT INTO [dbo].[sba_naics_sector_codes_description]
VALUES
('Sector 31 – 33 – Manufacturing', 32, 'Manufacturing'),
('Sector 31 – 33 – Manufacturing', 33, 'Manufacturing'),
('Sector 44 - 45 – Retail Trade', 45, 'Retail Trade'),
('Sector 48 - 49 – Transportation and Warehousing', 49, 'Transportation and Warehousing');
--
UPDATE [dbo].[sba_naics_sector_codes_description]
SET Sector = 'Manufacturing'
WHERE lookup_codes = 31;

SELECT * 
FROM [dbo].[sba_naics_sector_codes_description];

