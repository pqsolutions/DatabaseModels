USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are Damaged Sample or Timout Expiry Samples of particular ANM in Notification

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMNotificationSamples' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMNotificationSamples
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMNotificationSamples] 
(
	@ANMID INT
	,@Notification INT
	,@SearchValue VARCHAR(MAX)
)
AS
BEGIN
	IF @Notification = 1
	BEGIN
		IF @SearchValue = '' OR LEN(@SearchValue) = 0	
		BEGIN
			SELECT SC.[ID]
				,SC.[SubjectID] 
				,SP.[UniqueSubjectID]
				,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
				,SP.[SubjectTypeID]
				,ST.[SubjectType]
				,SC.[BarcodeNo] 
				,(CONVERT(VARCHAR,SC.[SampleCollectionDate],105)) AS  DateofCollection
				,SP.[MobileNo] AS ContactNo
				,ISNULL(SC.[NotifiedStatus],0) AS NotifiedStatus
				,(SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) AS GestationalAge
			FROM [dbo].[Tbl_SampleCollection] SC     
			LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[ID] = SC.[SubjectID]  
			LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[SubjectTypeID]    
			WHERE SC.[CollectedBy] = @ANMID  AND SC.[SampleDamaged] = 1 AND SC.[IsRecollected] != 'Y' AND SC.[IsAccept] = 0
		END
		ELSE
		BEGIN
			SELECT SC.[ID]
				,SC.[SubjectID] 
				,SP.[UniqueSubjectID]
				,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
				,SP.[SubjectTypeID]
				,ST.[SubjectType]
				,SC.[BarcodeNo] 
				,(CONVERT(VARCHAR,SC.[SampleCollectionDate],105)) AS  DateofCollection
				,SP.[MobileNo] AS ContactNo
				,ISNULL(SC.[NotifiedStatus],0) AS NotifiedStatus
				,(SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) AS GestationalAge
			FROM [dbo].[Tbl_SampleCollection] SC     
			LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[ID] = SC.[SubjectID]  
			LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[SubjectTypeID]    
			WHERE SC.[CollectedBy] = @ANMID  AND SC.[SampleDamaged] = 1 AND SC.[IsRecollected] != 'Y' 
			AND SC.[IsAccept] = 0 AND (SP.[UniqueSubjectID] = @SearchValue OR SC.[BarcodeNo] = @SearchValue  OR SP.[MobileNo] = @SearchValue
			OR SC.[SampleCollectionDate] = CONVERT(DATE,@SearchValue,103) OR SP.[FirstName] Like @SearchValue+'%')		
		END					
	END
	ELSE IF @Notification = 2
	BEGIN
		IF @SearchValue = '' OR LEN(@SearchValue) = 0	
		BEGIN
			SELECT SC.[ID]
				,SC.[SubjectID] 
				,SP.[UniqueSubjectID]
				,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
				,SP.[SubjectTypeID]
				,ST.[SubjectType]
				,SC.[BarcodeNo] 
				,(CONVERT(VARCHAR,SC.[SampleCollectionDate],105)) AS  DateofCollection
				,SP.[MobileNo] AS ContactNo
				,ISNULL(SC.[NotifiedStatus],0) AS NotifiedStatus
				,(SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) AS GestationalAge
			FROM [dbo].[Tbl_SampleCollection] SC     
			LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[ID] = SC.[SubjectID]  
			LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[SubjectTypeID]  
			WHERE SC.[CollectedBy] = @ANMID  AND SC.[SampleTimeoutExpiry] = 1 AND SC.[IsRecollected] != 'Y' AND SC.[IsAccept] = 0
		END
		ELSE
		BEGIN
			SELECT SC.[ID]
				,SC.[SubjectID] 
				,SP.[UniqueSubjectID]
				,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
				,SP.[SubjectTypeID]
				,ST.[SubjectType]
				,SC.[BarcodeNo] 
				,(CONVERT(VARCHAR,SC.[SampleCollectionDate],105)) AS  DateofCollection
				,SP.[MobileNo] AS ContactNo
				,ISNULL(SC.[NotifiedStatus],0) AS NotifiedStatus
				,(SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) AS GestationalAge
			FROM [dbo].[Tbl_SampleCollection] SC     
			LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[ID] = SC.[SubjectID]
			LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[SubjectTypeID]  
			WHERE SC.[CollectedBy] = @ANMID  AND SC.[SampleTimeoutExpiry] = 1 AND SC.[IsRecollected] != 'Y' 
			AND SC.[IsAccept] = 0 AND (SP.[UniqueSubjectID] = @SearchValue OR SC.[BarcodeNo] = @SearchValue  OR SP.[MobileNo] = @SearchValue
			OR SC.[SampleCollectionDate] = CONVERT(DATE,@SearchValue,103) OR SP.[FirstName] Like @SearchValue+'%')		
		END					
	END


	
END
      
