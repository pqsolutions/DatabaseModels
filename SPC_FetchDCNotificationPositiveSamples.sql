USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are positive Samples for  DC in Notification

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchDCNotificationPositiveSamples' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchDCNotificationPositiveSamples 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchDCNotificationPositiveSamples] 
(
	@DistrictId INT
)
AS
BEGIN
	
	SELECT SC.[ID] AS SampleCollectionId
		,SP.[UniqueSubjectID]
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
		,SPR.[RCHID] 
		,(SELECT [dbo].[FN_FindBarcodesByUser](SP.[ID])) AS BarcodeNo
		,SP.[MobileNo] AS ContactNo
		,SP.[Age]
		,SPR.[ECNumber]
		,SP.[Gender] 
		,ST.[SubjectType] 
		,(SAD.[Address1] + ' ' + SAD.[Address2] + ' ' + SAD.[Address3]) AS SubjectAddress
		,('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
		CONVERT(VARCHAR,SPR.[A])) AS GPLA
		,CONVERT(VARCHAR,SPR.[LMP_Date],103) AS LMPDate
		,CONVERT(VARCHAR,SP.[DOB] ,103) AS DateOFBirth
		,CAST((SELECT [dbo].[FN_CalculateGestationalAge](SPR.[SubjectID])) AS DECIMAL(18,1)) AS GestationalAge
		,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
		,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) AS SampleCollectionDate
		, CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS SampleCollectionTime
		,SP.[AssignANM_ID] 
		,(UM.[FirstName] + ' ' + UM.[LastName]) AS ANMName
		,UM.[ContactNo1] AS ANMContactNo
		,DM.[Districtname] AS District
		,CM.[CHCname] AS CHC
		,PM.[PHCname] AS PHC
		,S.[SCname] AS SCName
		,RI.[RIsite] 
		,RM.[Religionname]
		,CA.[Castename] 
		,CO.[Communityname] 
		,PRSD.[CBCResult] AS CBCResult
		,CASE WHEN PRSD.[SSTStatus] = 'P' THEN 'Positive' ELSE 'Negative' END AS SSTResult
		,PRSD.[HPLCTestResult] AS HPLCResult
		,ISNULL(PRSD.[FollowUpStatus],0) AS FollowUPStatus
	FROM [dbo].[Tbl_SampleCollection] SC     
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[ID] = SC.[SubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail]  SPR WITH (NOLOCK) ON SPR.[SubjectID] = SP.[ID] 
	LEFT JOIN  [dbo].[Tbl_SubjectAddressDetail]   SAD WITH (NOLOCK) ON SAD.[SubjectID] = SP.[ID]  
	LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[SubjectTypeID] 
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = SP.[AssignANM_ID] 
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK) ON DM.[ID] = SP.[DistrictID] 
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.[ID] = SP.[CHCID] 
	LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK) ON PM.[ID] = SP.[PHCID]  
	LEFT JOIN [dbo].[Tbl_SCMaster] S WITH (NOLOCK) ON S.[ID] = SP.[SCID]   
	LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK) ON RI.[ID] = SP.[RIID]
	LEFT JOIN [dbo].[Tbl_ReligionMaster] RM WITH (NOLOCK) ON RM.[ID] = SAD.[Religion_Id] 
	LEFT JOIN [dbo].[Tbl_CasteMaster] CA WITH (NOLOCK) ON CA.[ID]  = SAD.[Caste_Id]  
	LEFT JOIN [dbo].[Tbl_CommunityMaster] CO WITH (NOLOCK) ON CO.[ID]  = SAD.[Community_Id]
	LEFT JOIN [dbo].[Tbl_PositiveResultSubjectsDetail] PRSD WITH (NOLOCK) ON PRSD.[BarcodeNo]  = SC .[BarcodeNo]   
	WHERE SP.[DistrictID]  = @DistrictId  AND PRSD.[HPLCStatus] = 'P' 
	AND (PRSD.[HPLCNotifiedStatus] = 0 OR  PRSD.[HPLCNotifiedStatus] IS NULL)
	ORDER BY GestationalAge DESC	 		
	
END