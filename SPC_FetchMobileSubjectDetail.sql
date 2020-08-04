USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileSubjectDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileSubjectDetail
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobileSubjectDetail]
(
	@UserId INT
)AS
BEGIN
	SELECT 
		SP.[SubjectTypeID]
		,SP.[ChildSubjectTypeID]
		,SP.[UniqueSubjectID]
		,SP.[DistrictID]
		,SP.[CHCID]
		,SP.[PHCID]
		,SP.[SCID]
		,SP.[RIID]
		,SP.[SubjectTitle]
		,SP.[FirstName]
		,SP.[MiddleName]
		,SP.[LastName]
		,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' 
			  ELSE CONVERT(VARCHAR,SP.[DOB],103)
		 END  AS  DateOfBirth
		,SP.[Age]
		,SP.[Gender]
		,SP.[MaritalStatus]
		,SP.[MobileNo]
		,SP.[EmailId]
		,SP.[GovIdType_ID]
		,SP.[GovIdDetail]
		,SP.[SpouseSubjectID]
		,SP.[Spouse_FirstName]
		,SP.[Spouse_MiddleName]
		,SP.[Spouse_LastName]
		,SP.[Spouse_ContactNo]
		,SP.[Spouse_GovIdType_ID]
		,SP.[Spouse_GovIdDetail]
		,SP.[AssignANM_ID]
		,CASE WHEN ISNULL(SP.[DateofRegister],'') = '' THEN '' 
			  ELSE CONVERT(VARCHAR,SP.[DateofRegister],103)
		 END  AS  RegisterDate
		 ,SP.[RegisteredFrom]
		,SP.[CreatedBy]
		,SP.[UpdatedBy] 
		,SP.[IsActive]
		,RIGHT(SP.[UniqueSubjectID],1) AS RegSource
		,SAD.[UniqueSubjectID] AS SAD_UniqueSubjectId
		,SAD.[Religion_Id]
		,SAD.[Caste_Id]
		,SAD.[Community_Id]
		,SAD.[Address1]
		,SAD.[Address2]
		,SAD.[Address3]
		,SAD.[Pincode]
		,SAD.[StateName]
		,SAD.[UpdatedBy] AS A_UpdatedBy
		,SPD.[UniqueSubjectID] AS APD_UniqueSubjectId
		,SPD.[RCHID]
		,SPD.[ECNumber]
		,CASE WHEN ISNULL(SPD.[LMP_Date],'') = '' THEN '' 
			  ELSE CONVERT(VARCHAR,SPD.[LMP_Date],103)
		 END  AS  LMPDate
		,SPD.[G]
		,SPD.[P]
		,SPD.[L]
		,SPD.[A]
		,SPD.[UpdatedBy] AS PR_UpdatedBy
		,SPAD.[UniqueSubjectID] AS SPA_UniqueSubjectId 
		,SPAD.[Mother_FirstName]
		,SPAD.[Mother_MiddleName]
		,SPAD.[Mother_LastName]
		,SPAD.[Mother_GovIdType_ID] 
		,SPAD.[Mother_GovIdDetail] 
		,SPAD.[Mother_ContactNo]
		,SPAD.[Father_FirstName]
		,SPAD.[Father_MiddleName]
		,SPAD.[Father_LastName]
		,SPAD.[Father_GovIdType_ID]  
		,SPAD.[Father_GovIdDetail] 
		,SPAD.[Father_ContactNo]
		,SPAD.[Gaurdian_FirstName]
		,SPAD.[Gaurdian_MiddleName]
		,SPAD.[Gaurdian_LastName]
		,SPAD.[Guardian_GovIdType_ID]  
		,SPAD.[Guardian_GovIdDetail]
		,SPAD.[Gaurdian_ContactNo]
		,SPAD.[RBSKId]
		,SPAD.[SchoolName]
		,SPAD.[SchoolAddress1]
		,SPAD.[SchoolAddress2]
		,SPAD.[SchoolAddress3]
		,SPAD.[SchoolPincode]
		,SPAD.[SchoolCity]
		,SPAD.[SchoolState]
		,SPAD.[Standard]
		,SPAD.[Section]
		,SPAD.[RollNo]
		,SPAD.[UpdatedBy] AS SPA_UpdatedBy
		,(SELECT [dbo].[FN_FindResult](SPAD.[UniqueSubjectID],'CBC')) AS CBCTestResult
		,(SELECT [dbo].[FN_FindResult](SPAD.[UniqueSubjectID],'SST')) AS SSTestResult
		,(SELECT [dbo].[FN_FindResult](SPAD.[UniqueSubjectID],'HPLC')) AS HPLCTestResult
		,CASE WHEN (SELECT [dbo].[FN_FindResult](SPAD.[UniqueSubjectID],'HPLC')) = '' THEN 0 ELSE 1 END AS IsHPLCPositive
	FROM [dbo].[Tbl_SubjectPrimaryDetail] SP
	LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SP.[ID] = SAD.[SubjectID]
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SP.[ID] = SPD.[SubjectID]
	LEFT JOIN [dbo].[Tbl_SubjectParentDetail] SPAD WITH (NOLOCK) ON SP.[ID] = SPAD.[SubjectID]
	WHERE SP.[AssignANM_ID] = @UserId -- AND SP.[IsActive] = 1 
	AND  SPAD.[UniqueSubjectID] IN (SELECT UniqueSubjectID  FROM Tbl_SubjectPrimaryDetail)
END