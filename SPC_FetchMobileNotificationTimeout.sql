USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are Sample Timeout Expiry particular ANM in Tab Notification

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileNotificationTimeout' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileNotificationTimeout 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobileNotificationTimeout] 
(
	@ANMID INT
)
AS
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
		,SC.[BarcodeNo] 
		,SP.[MobileNo]
		,SC.[NotifiedStatus] AS IsNotified
		,CASE WHEN SC.[NotifiedOn] IS NULL THEN NULL ELSE CONVERT(VARCHAR,SC.[NotifiedOn],103) END AS NotifiedOn
		,CONVERT(VARCHAR,SP.[DateofRegister],103) AS DateofRegister 
		,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) AS SampleCollectionDate
		,CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS SampleCollectionTime
		,(SELECT [dbo].[FN_CalculateGestationalAge](SPR.[SubjectID])) AS [GestationalAge]
	FROM [dbo].[Tbl_SampleCollection] SC     
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[ID] = SC.[SubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail]  SPR WITH (NOLOCK) ON SPR.[SubjectID] = SP.[ID]   
	LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[SubjectTypeID]  
	WHERE SC.[CollectedBy] = @ANMID  AND SC.[SampleTimeoutExpiry]  = 1 AND SC.[IsRecollected] != 'Y' AND SP.[IsActive] = 1
	ORDER BY [GestationalAge] DESC
END
