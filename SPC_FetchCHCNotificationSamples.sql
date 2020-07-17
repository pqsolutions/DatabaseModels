USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are Damaged Sample or Timout Expiry Samples of particular CHC in Notification

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCHCNotificationSamples' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCHCNotificationSamples 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchCHCNotificationSamples] 
(
	@UserId INT
	,@CollectedFrom INT
	,@Notification INT
)
AS
	DECLARE  @CHCID INT
BEGIN
	SELECT  @CHCID = CHCID FROM Tbl_UserMaster WHERE ID = @UserID
	
	IF @Notification = 1
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
			,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
			,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) AS SampleCollectionDate
			,CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS SampleCollectionTime
		FROM [dbo].[Tbl_SampleCollection] SC     
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[ID] = SC.[SubjectID] 
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail]  SPR WITH (NOLOCK) ON SPR.[SubjectID] = SP.[ID]   
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[SubjectTypeID]    
		WHERE SP.CHCID = @CHCID AND SC.CollectionFrom = @CollectedFrom    AND SC.[SampleDamaged] = 1 AND SC.[IsRecollected] != 'Y' 
		ORDER BY GestationalAge DESC	 		
	END
	ELSE IF @Notification = 3
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
			,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
			,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) AS SampleCollectionDate
			,CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS SampleCollectionTime
		FROM [dbo].[Tbl_SampleCollection] SC     
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[ID] = SC.[SubjectID]
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail]  SPR WITH (NOLOCK) ON SPR.[SubjectID] = SP.[ID]  
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[SubjectTypeID]  
		WHERE  SP.CHCID = @CHCID AND SC.CollectionFrom = @CollectedFrom   AND SC.[SampleTimeoutExpiry] = 1 AND SC.[IsRecollected] != 'Y' 
		ORDER BY GestationalAge DESC		
	END	
	ELSE IF @Notification = 2 
	BEGIN
		SELECT SC.[UniqueSubjectID]
		  ,SC.[ID] AS SampleCollectionId
		  ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
		  ,SPR.[RCHID] 
		  ,SC.[BarcodeNo]
		  ,SP.[MobileNo] AS ContactNo
		  ,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
		  ,CAST((SELECT [dbo].[FN_CalculateGestationalAge](SPR.[SubjectID])) AS DECIMAL(18,1)) AS GestationalAge
		   FROM Tbl_SampleCollection SC
		   LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.ID = SC.SubjectID
		   LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.SubjectID = SP.ID
		WHERE SC.CollectionFrom  = @CollectedFrom AND SP.CHCID = @CHCID  AND SC.SampleTimeoutExpiry != 1 AND SC.SampleDamaged != 1
		AND SC.BarcodeNo NOT IN (SELECT BarcodeNo from Tbl_ANMCHCShipmentsDetail)
		ORDER BY GestationalAge DESC
	END
				
END
      
