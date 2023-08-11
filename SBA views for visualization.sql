CREATE VIEW ppp_mains AS
SELECT d.Sector,  
	YEAR(DateApproved) AS year_approved,
	MONTH(DateApproved) AS month_Approved,
	OriginatingLender, 	
	BorrowerState,
	Race,
	Gender,
	Ethnicity,
	COUNT(LoanNumber) AS Number_of_Approved,
	SUM(CurrentApprovalAmount) AS Current_Approved_Amount,
	AVG(CurrentApprovalAmount) AS Current_Average_loan_size,
	SUM(ForgivenessAmount) AS Amount_Forgiven,
	SUM(InitialApprovalAmount) AS Approved_Amount,
	AVG(InitialApprovalAmount) AS Average_loan_size
FROM [Portfolio_projectsDB].[dbo].[SBA_public_datas] p
INNER JOIN [dbo].[sba_naics_sector_codes_description] d
	ON LEFT(p.NAICSCode, 2) = d.lookup_codes
GROUP BY 
	d.Sector,  
	YEAR(DateApproved),
	MONTH(DateApproved),
	OriginatingLender, 	
	BorrowerState,
	Race,
	Gender,
	Ethnicity

	