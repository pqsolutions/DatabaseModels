USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_FetchCHCPositiveSubjectDetail' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchCHCPositiveSubjectDetail
End
GO
CREATE PROCEDURE [dbo].[SPC_FetchCHCPositiveSubjectDetail]
(
	@CHCId INT
	,@RegisteredFrom INT
)AS
BEGIN
	SELECT SPRD.[ID] 
			,SPRD.[SubjectTypeID]
			,SPRD.[ChildSubjectTypeID]
			,SPRD.[UniqueSubjectID]
			,SPRD.[DistrictID]
			,SPRD.[CHCID]
			,SPRD.[PHCID]
			,SPRD.[SCID]
			,SPRD.[RIID]
			,SPRD.[SubjectTitle]
			,(SPRD.[FirstName] + ' ' + SPRD.[MiddleName] + ' ' + SPRD.[LastName]) AS SubjectName
			,SPRD.[MobileNo] AS ContactNo
			,SPRD.[Spouse_FirstName]
			,SPRD.[Spouse_MiddleName]
			,SPRD.[Spouse_LastName]
			,SPRD.[Spouse_ContactNo]
			,ISNULL(SPRD.[Spouse_GovIdType_ID] ,0) AS Spouse_GovIdType_ID
			,SPRD.[Spouse_GovIdDetail] 
			,SAD.[Religion_Id]
			,SAD.[Caste_Id]
			,SAD.[Community_Id]
			,SAD.[Address1]
			,SAD.[Address2]
			,SAD.[Address3]
			,SAD.[Pincode]
			,SAD.[StateName] 
			,SPD.[RCHID]
			,SPD.[ECNumber]
			,(SELECT [dbo].[FN_CalculateGestationalAge](SPD.[SubjectID])) AS [GestationalAge]
			,1 AS RegisterSpouse
			,ISNULL(PRSD.[HPLCNotifiedStatus],0) AS NotifiedStatus
			,PRSD.[BarcodeNo] 
			,PRSD.[HPLCTestResult] 
	FROM [dbo].[Tbl_SubjectPrimaryDetail] AS SPRD
	LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPRD.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[SubjectID] = SPRD.[ID]
	LEFT JOIN [dbo].[Tbl_PositiveResultSubjectsDetail] PRSD WITH (NOLOCK) ON PRSD.[BarcodeNo]  = SC .[BarcodeNo] 
	WHERE  SPRD.[CHCID] = @CHCId AND SPRD.[RegisteredFrom] = @RegisteredFrom  AND ISNULL(SPRD.[SpouseSubjectID],'') = '' 
	AND SPRD.[UniqueSubjectID] NOT IN (SELECT SpouseSubjectID  FROM [dbo].[Tbl_SubjectPrimaryDetail]
	WHERE (SPRD.[SubjectTypeID] = 2 OR SPRD.[ChildSubjectTypeID] = 2))
	AND PRSD.[HPLCStatus] = 'P' AND (SPRD.[SubjectTypeID] = 1 OR SPRD.[ChildSubjectTypeID] = 1)
	
	UNION 
	SELECT SPRD.[ID] 
			,SPRD.[SubjectTypeID]
			,SPRD.[ChildSubjectTypeID]
			,SPRD.[UniqueSubjectID]
			,SPRD.[DistrictID]
			,SPRD.[CHCID]
			,SPRD.[PHCID]
			,SPRD.[SCID]
			,SPRD.[RIID]
			,SPRD.[SubjectTitle]
			,(SPRD.[FirstName] + ' ' + SPRD.[MiddleName] + ' ' + SPRD.[LastName]) AS SubjectName
			,SPRD.[MobileNo] AS ContactNo
			,SPRD.[Spouse_FirstName]
			,SPRD.[Spouse_MiddleName]
			,SPRD.[Spouse_LastName]
			,SPRD.[Spouse_ContactNo]
			,ISNULL(SPRD.[Spouse_GovIdType_ID] ,0) AS Spouse_GovIdType_ID
			,SPRD.[Spouse_GovIdDetail] 
			,SAD.[Religion_Id]
			,SAD.[Caste_Id]
			,SAD.[Community_Id]
			,SAD.[Address1]
			,SAD.[Address2]
			,SAD.[Address3]
			,SAD.[Pincode]
			,SAD.[StateName] 
			,SPD.[RCHID]
			,SPD.[ECNumber]
			,(SELECT [dbo].[FN_CalculateGestationalAge](SPD.[SubjectID])) AS [GestationalAge]
			,0 AS RegisterSpouse
			,ISNULL(PRSD.[HPLCNotifiedStatus],0) AS NotifiedStatus
			,PRSD.[BarcodeNo]
			,PRSD.[HPLCTestResult] 
	FROM [dbo].[Tbl_SubjectPrimaryDetail] AS SPRD
	LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPRD.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[SubjectID] = SPRD.[ID]
	LEFT JOIN [dbo].[Tbl_PositiveResultSubjectsDetail] PRSD WITH (NOLOCK) ON PRSD.[BarcodeNo]  = SC .[BarcodeNo] 
	WHERE  SPRD.[CHCID] = @CHCId AND SPRD.[RegisteredFrom] = @RegisteredFrom  AND PRSD.[HPLCNotifiedStatus]   != 1 AND PRSD.[HPLCStatus] = 'P'
	AND (SPRD.[SubjectTypeID] != 1 OR SPRD.[ChildSubjectTypeID] != 1)
	
	ORDER BY [GestationalAge] DESC
END