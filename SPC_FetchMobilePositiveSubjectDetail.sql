USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_FetchMobilePositiveSubjectDetail' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchMobilePositiveSubjectDetail 
End
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobilePositiveSubjectDetail]
(
	@ANMID INT
)AS
BEGIN
	SELECT SC.[ID] AS SampleCollectionId
		,SP.[SubjectTypeID] 
		,SP.[ChildSubjectTypeID] 
		,SP.[UniqueSubjectID]
		,SP.[FirstName]
		,SP.[MiddleName]
		,SP.[LastName]
		,SPR.[RCHID] 
		,CASE WHEN (SPR.[ECNumber] = '' OR SPR.[ECNumber] IS NULL)  THEN NULL ELSE SPR.[ECNumber] END AS ECNumber
		,CASE WHEN (SPR.[LMP_Date] = '' OR SPR.[LMP_Date] IS NULL)  THEN NULL ELSE CONVERT(VARCHAR,SPR.[LMP_Date],103) END AS LMPDate
		,SP.[MobileNo]
		,ISNULL(PRSD.[HPLCNotifiedStatus],0) AS IsNotified
		,CASE WHEN PRSD.[HPLCNotifiedOn] IS NULL THEN NULL ELSE CONVERT(VARCHAR, PRSD.[HPLCNotifiedOn],103) END AS NotifiedOn
		,PRSD.[BarcodeNo] 
		,PRSD.[HPLCTestResult] 
		,CONVERT(DECIMAL(10,1),(SELECT [dbo].[FN_CalculateGestationalAge](SPR.[SubjectID]))) AS [GestationalAge]
	FROM [dbo].[Tbl_SubjectPrimaryDetail] AS SP
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR WITH (NOLOCK) ON SPR.[UniqueSubjectID] = SP.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[SubjectID] = SP.[ID]
	LEFT JOIN [dbo].[Tbl_PositiveResultSubjectsDetail] PRSD WITH (NOLOCK) ON PRSD.[BarcodeNo]  = SC .[BarcodeNo] 
	WHERE  SP.[AssignANM_ID] = @ANMID AND ISNULL(SP.[SpouseSubjectID],'') = '' 
	AND SP.[UniqueSubjectID] NOT IN (SELECT SpouseSubjectID  FROM [dbo].[Tbl_SubjectPrimaryDetail]
	WHERE (SP.[SubjectTypeID] = 2 OR SP.[ChildSubjectTypeID] = 2))
	AND PRSD.[HPLCStatus] = 'P' AND (SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1) AND SP.[SpouseWillingness] = 1
	
	UNION 
	SELECT  SC.[ID] AS SampleCollectionId
		,SP.[SubjectTypeID] 
		,SP.[ChildSubjectTypeID] 
		,SP.[UniqueSubjectID]
		,SP.[FirstName]
		,SP.[MiddleName]
		,SP.[LastName]
		,SPR.[RCHID] 
		,CASE WHEN (SPR.[ECNumber] = '' OR SPR.[ECNumber] IS NULL)  THEN NULL ELSE SPR.[ECNumber] END AS ECNumber
		,CASE WHEN (SPR.[LMP_Date] = '' OR SPR.[LMP_Date] IS NULL)  THEN NULL ELSE CONVERT(VARCHAR,SPR.[LMP_Date],103) END AS LMPDate
		,SP.[MobileNo]
		,ISNULL(PRSD.[HPLCNotifiedStatus],0) AS IsNotified
		,CASE WHEN PRSD.[HPLCNotifiedOn] IS NULL THEN NULL ELSE CONVERT(VARCHAR, PRSD.[HPLCNotifiedOn],103) END AS NotifiedOn
		,PRSD.[BarcodeNo] 
		,PRSD.[HPLCTestResult] 
		,CONVERT(DECIMAL(10,1),(SELECT [dbo].[FN_CalculateGestationalAge](SPR.[SubjectID]))) AS [GestationalAge]
	FROM [dbo].[Tbl_SubjectPrimaryDetail] AS SP
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR WITH (NOLOCK) ON SPR.[UniqueSubjectID] = SP.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[SubjectID] = SP.[ID]
	LEFT JOIN [dbo].[Tbl_PositiveResultSubjectsDetail] PRSD WITH (NOLOCK) ON PRSD.[BarcodeNo]  = SC .[BarcodeNo]
	WHERE  SP.[AssignANM_ID] = @ANMID AND( PRSD.[HPLCNotifiedStatus] IS NULL OR PRSD.[HPLCNotifiedStatus] = 0) AND PRSD.[HPLCStatus] = 'P'
	AND (SP.[SubjectTypeID] = 2 OR SP.[ChildSubjectTypeID] = 2 OR  SP.[ChildSubjectTypeID] = 4)  AND SP.[UpdatedToANM] IS NULL
	ORDER BY [GestationalAge] DESC
	
END