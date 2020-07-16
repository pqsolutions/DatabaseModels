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
		,SP.[UniqueSubjectID]
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
		,SPR.[RCHID] 
		,SC.[BarcodeNo] 
		,SP.[MobileNo] AS ContactNo
		,ISNULL(SC.[NotifiedStatus],0) AS NotifiedStatus
		,CAST((SELECT [dbo].[FN_CalculateGestationalAge](SPR.[SubjectID])) AS DECIMAL(18,1)) AS GestationalAge
		,(SELECT [dbo].[FN_FindSampleType](SP.[ID])) AS SampleType
		,(SELECT [dbo].[FN_FindSampleTypeReason](SP.[ID])) AS Reason
	FROM [dbo].[Tbl_SampleCollection] SC     
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[ID] = SC.[SubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail]  SPR WITH (NOLOCK) ON SPR.[SubjectID] = SP.[ID]   
	LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[SubjectTypeID]    
	WHERE SC.[CollectedBy] = @ANMID  AND SC.[SampleTimeoutExpiry]  = 1 AND SC.[IsRecollected] != 'Y' 
	ORDER BY GestationalAge DESC	 		
END
