--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchErrorBarcodeDetailForSMS' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchErrorBarcodeDetailForSMS 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchErrorBarcodeDetailForSMS] 
(
	@Id INT
)
AS
BEGIN
	SELECT  EB.[Barcode] 
			,EB.[UniqueSubjectID]
			,EB.[ExistUniqueSubjectID]  
			,SP.[FirstName] AS SubjectName
			,SP1.[FirstName] AS ExistSubjectName
			,SP.[MobileNo] AS SubjectMobilNo
			,SP1.[MobileNo] AS ExistSubjectMobilNo
			,(UM.[FirstName]) AS ANMName
			,UM.[ContactNo1] AS ANMMobileNo
			,(UM1.[FirstName]) AS ExistANMName
			,UM1.[ContactNo1] AS ExistANMMobileNo
			,SM.[SCname] AS ANMSCName
			,SM1.[SCname] AS ExistANMSCName
			,CONVERT(VARCHAR,EB.[SampleCollectionDate],103) AS SampleCollectionDate
			,CONVERT(VARCHAR,EB.[ExistSampleCollectionDate],103) AS ExistSampleCollectionDate
			,EB.[ANMId]
			,EB.[ExistANMId]
			,CM.[CHCname] AS CHCName
			,CM1.[CHCname] AS ExistCHCName
			,PM.[PHCname] AS PHCName
			,PM1.[PHCname] AS ExistPHCName
			,CONVERT(VARCHAR,SP.[DateofRegister],103) AS RegDate
			,CONVERT(VARCHAR,SP1.[DateofRegister],103) AS ExistRegDate
	FROM [dbo].[Tbl_ErrorBarcodeDetail] EB
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = EB.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP1 WITH (NOLOCK) ON SP1.[UniqueSubjectID] = EB.[ExistUniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_UserMaster] UM ON UM.[ID] = SP.[AssignANM_ID]
	LEFT JOIN [dbo].[Tbl_UserMaster] UM1 ON UM1.[ID] = SP1.[AssignANM_ID]
	LEFT JOIN [dbo].[Tbl_SCMaster] SM ON UM.[SCID] = SM.[ID]
	LEFT JOIN [dbo].[Tbl_SCMaster] SM1 ON UM1.[SCID] = SM1.[ID]
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM ON CM.[ID] = SP.[CHCID]
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM1 ON CM1.[ID] = SP1.[CHCID]
	LEFT JOIN [dbo].[Tbl_PHCMaster] PM ON PM.[ID] = SP.[PHCID]
	LEFT JOIN [dbo].[Tbl_PHCMaster] PM1 ON PM1.[ID] = SP1.[PHCID]
	WHERE EB.[ID]  = @Id 
END