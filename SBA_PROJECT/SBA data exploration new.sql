--SBA Data Exploration
SELECT *
  FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas];

--What is the summary of all approved ppp Loans
SELECT COUNT (LoanNumber) AS Number_of_Approved,
SUM(InitialApprovalAmount) AS Total_Approved_Amount,
AVG (InitialApprovalAmount) AS Average_loan_size
  FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas];

---
SELECT 
	YEAR(DateApproved) AS Year_Approved,
	COUNT (LoanNumber) AS Number_of_Approved,
	SUM(InitialApprovalAmount) AS Total_Approved_Amount,
	AVG (InitialApprovalAmount) AS Average_loan_size
FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas]
WHERE YEAR(DateApproved)= 2020
GROUP BY YEAR(DateApproved)

UNION 
SELECT 
	YEAR(DateApproved) AS Year_Approved,
	COUNT (LoanNumber) AS Number_of_Approved,
	SUM(InitialApprovalAmount) AS Total_Approved_Amount,
	AVG (InitialApprovalAmount) AS Average_loan_size
FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas]
WHERE YEAR(DateApproved)= 2021
GROUP BY YEAR(DateApproved);


--11,468,417
--796,817,988,128.791
--69479.3351278377

--Originating lenders that were involved in 2021

SELECT 
	COUNT (DISTINCT OriginatingLender) AS OrginatingLender,
	YEAR(DateApproved) AS Year_Approved,
	COUNT (LoanNumber) AS Number_of_Approved,
	SUM(InitialApprovalAmount) AS Total_Approved_Amount,
	AVG (InitialApprovalAmount) AS Average_loan_size
FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas]
WHERE YEAR(DateApproved)= 2020
GROUP BY YEAR(DateApproved)


UNION 
SELECT 
	COUNT (DISTINCT OriginatingLender) AS OrginatingLender,
	YEAR(DateApproved) AS Year_Approved,
	COUNT (LoanNumber) AS Number_of_Approved,
	SUM(InitialApprovalAmount) AS Total_Approved_Amount,
	AVG (InitialApprovalAmount) AS Average_loan_size
FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas]
WHERE YEAR(DateApproved)= 2021
GROUP BY YEAR(DateApproved);

--Top 20 Orignating Lender by Loan count, total amount and average in 2021
SELECT TOP 20
    OriginatingLender,
	COUNT (LoanNumber) AS Number_of_Approved,
	SUM(InitialApprovalAmount) AS Total_Approved_Amount,
	AVG (InitialApprovalAmount) AS Average_loan_size
FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas]
WHERE YEAR(DateApproved)= 2021
GROUP BY OriginatingLender
ORDER BY SUM(InitialApprovalAmount) DESC;

--Top 20 Orignating Lender by Loan count, total amount and average in 2020

SELECT TOP 20
    OriginatingLender,
	COUNT (LoanNumber) AS Number_of_Approved,
	SUM(InitialApprovalAmount) AS Total_Approved_Amount,
	AVG (InitialApprovalAmount) AS Average_loan_size
FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas]
WHERE YEAR(DateApproved)= 2020
GROUP BY OriginatingLender
ORDER BY SUM(InitialApprovalAmount) DESC;

--Top 20 industries that received the PPP Loans in 2020
SELECT TOP 20
    d.Sector,
	COUNT (LoanNumber) AS Number_of_Approved,
	SUM(InitialApprovalAmount) AS Total_Approved_Amount,
	AVG (InitialApprovalAmount) AS Average_loan_size
FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas] p
INNER JOIN [dbo].[sba_naics_sector_codes_description] d
ON LEFT(p.NAICSCode, 2) = d.lookup_codes
WHERE YEAR(DateApproved)= 2020
GROUP BY d.Sector
ORDER BY SUM(InitialApprovalAmount) DESC;

--Top 20 industries that received the PPP Loans in 2020

SELECT TOP 20
    d.Sector,
	COUNT (LoanNumber) AS Number_of_Approved,
	SUM(InitialApprovalAmount) AS Total_Approved_Amount,
	AVG (InitialApprovalAmount) AS Average_loan_size
FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas] p
INNER JOIN [dbo].[sba_naics_sector_codes_description] d
ON LEFT(p.NAICSCode, 2) = d.lookup_codes
WHERE YEAR(DateApproved)= 2021
GROUP BY d.Sector
ORDER BY SUM(InitialApprovalAmount) DESC;

--Percentage by Amount in Year 2021
WITH CTE AS (
SELECT TOP 20
    d.Sector,
	COUNT (LoanNumber) AS Number_of_Approved,
	SUM(InitialApprovalAmount) AS Total_Approved_Amount,
	AVG (InitialApprovalAmount) AS Average_loan_size
FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas] p
INNER JOIN [dbo].[sba_naics_sector_codes_description] d
ON LEFT(p.NAICSCode, 2) = d.lookup_codes
WHERE YEAR(DateApproved)= 2021
GROUP BY d.Sector)

SELECT Sector, Number_of_Approved, Total_Approved_Amount,
Total_Approved_Amount/SUM(Total_Approved_Amount) OVER() * 100 AS Percentage_by_Amount
FROM  CTE
ORDER BY Total_Approved_Amount DESC

-- How much of the PPP Loans of 2021 have been fully forgiven
SELECT
	COUNT (LoanNumber) AS Number_of_Approved,
	SUM(CurrentApprovalAmount) AS Current_Approved_Amount,
	AVG (CurrentApprovalAmount) AS Current_Average_loan_size,
	SUM(ForgivenessAmount) AS Amount_Forgiven,
	SUM(ForgivenessAmount)/SUM(CurrentApprovalAmount) * 100 AS Percent_forgiven
FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas] 
WHERE YEAR(DateApproved)= 2021
ORDER BY 5 DESC;

-- How much of the PPP Loans of 2020 have been fully forgiven
SELECT
	COUNT (LoanNumber) AS Number_of_Approved,
	SUM(CurrentApprovalAmount) AS Current_Approved_Amount,
	AVG (CurrentApprovalAmount) AS Current_Average_loan_size,
	SUM(ForgivenessAmount) AS Amount_Forgiven,
	SUM(ForgivenessAmount)/SUM(CurrentApprovalAmount) * 100 AS Percent_forgiven
FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas] 
WHERE YEAR(DateApproved)= 2020
ORDER BY 5 DESC;

--How much of the PPP Loands have been fully forgiven 
SELECT
	COUNT (LoanNumber) AS Number_of_Approved,
	SUM(CurrentApprovalAmount) AS Current_Approved_Amount,
	AVG (CurrentApprovalAmount) AS Current_Average_loan_size,
	SUM(ForgivenessAmount) AS Amount_Forgiven,
	SUM(ForgivenessAmount)/SUM(CurrentApprovalAmount) * 100 AS Percent_forgiven
FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas];

--Year and Month with the Highest PPP loans approved.
SELECT 
 YEAR(DateApproved) AS Year_approved,
 MONTH(DateApproved) AS Month_Approved,
 COUNT(LoanNumber) AS Number_of_Approved_loans,
 SUM(InitialApprovalAmount) AS Total_Net_Dollars,
 AVG(InitialApprovalAmount) AS Average_Loan_size
 FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas]
 GROUP BY YEAR(DateApproved),
		  MONTH(DateApproved)
ORDER BY 4  DESC;


