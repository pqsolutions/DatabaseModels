USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are Damaged Sample or Timout Expiry or Unsent Samples for  DC in Notification

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchDCNotificationSamples' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchDCNotificationSamples 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchDCNotificationSamples] 
(
	@DistrictId INT
	,@Notification INT
)
AS
BEGIN
	IF @Notification = 1
	BEGIN
		SELECT SC.[ID] AS SampleCollectionId
			,SP.[UniqueSubjectID]
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
			,SPR.[RCHID] 
			,SC.[BarcodeNo] 
			,SP.[MobileNo] AS ContactNo
			,SP.[Age]
			,SPR.[ECNumber]
			,SP.[Gender] 
			,ST.[SubjectType] 
			,(SAD.[Address1] + ' ' + SAD.[Address2] + ' ' + SAD.[Address3]) AS SubjectAddress
			,ISNULL(SC.[FollowUpStatus],0) AS FollowUPStatus
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
		WHERE SP.[DistrictID]  = @DistrictId   AND SC.[SampleDamaged] = 1 AND SC.[IsRecollected] != 'Y'  AND SC.[NotifiedStatus] = 0
		ORDER BY GestationalAge DESC	 		
	END
	IF @Notification = 3
	BEGIN
		SELECT SC.[ID] AS SampleCollectionId
			,SP.[UniqueSubjectID]
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
			,SPR.[RCHID] 
			,SC.[BarcodeNo] 
			,SP.[MobileNo] AS ContactNo
			,SP.[Age]
			,SPR.[ECNumber]
			,SP.[Gender]  
			,ST.[SubjectType]
			,(SAD.[Address1] + ' ' + SAD.[Address2] + ' ' + SAD.[Address3]) AS SubjectAddress
			,ISNULL(SC.[FollowUpStatus],0) AS FollowUPStatus
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
		WHERE SP.[DistrictID]  = @DistrictId   AND SC.[SampleTimeoutExpiry] = 1 AND SC.[NotifiedStatus] = 0
		ORDER BY GestationalAge DESC	 		
	END
	IF @Notification = 2
	BEGIN
		SELECT SC.[ID] AS SampleCollectionId
			,SP.[UniqueSubjectID]
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
			,SPR.[RCHID] 
			,SC.[BarcodeNo] 
			,SP.[MobileNo] AS ContactNo
			,SP.[Age]
			,SPR.[ECNumber]
			,SP.[Gender] 
			,ST.[SubjectType] 
			,(SAD.[Address1] + ' ' + SAD.[Address2] + ' ' + SAD.[Address3]) AS SubjectAddress
			,ISNULL(SC.[FollowUpStatus],0) AS FollowUPStatus
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
		WHERE SP.[DistrictID]  = @DistrictId   AND SC.SampleTimeoutExpiry != 1 AND SC.SampleDamaged != 1 AND SC.[FollowUpStatus] = 0
		AND SC.BarcodeNo NOT IN (SELECT BarcodeNo from Tbl_ANMCHCShipmentsDetail) 
		ORDER BY GestationalAge DESC	 		
	END
END