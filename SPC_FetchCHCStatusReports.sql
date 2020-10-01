USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCHCStatusReports' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCHCStatusReports
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchCHCStatusReports] 
(
	@SampleStatus INT
	,@TestingCHCId INT
	,@CHCID INT
	,@PHCID INT
	,@ANMID INT
	,@FromDate VARCHAR(100)
	,@ToDate VARCHAR(100)
)
AS
	DECLARE @StatusName VARCHAR(200),@StartDate VARCHAR(50), @EndDate VARCHAR(50)
BEGIN
	IF @FromDate = NULL OR @FromDate = ''
	BEGIN
		SET @StartDate = (SELECT CONVERT(VARCHAR,DATEADD(YEAR ,-1,GETDATE()),103))
	END
	ELSE
	BEGIN
		SET @StartDate = @FromDate
	END
	IF @ToDate = NULL OR @ToDate = ''
	BEGIN
		SET @EndDate = (SELECT CONVERT(VARCHAR,GETDATE(),103))
	END
	ELSE
	BEGIN
		SET @EndDate = @ToDate
	END
	SET  @StatusName = (SELECT StatusName FROM Tbl_CHCSampleStatusMaster WHERE ID = @SampleStatus)
	
	IF @StatusName =  'Samples Shipped' OR @SampleStatus=0
	BEGIN
		SELECT SP.[ID] AS SubjectId
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
			,SD.[UniqueSubjectID]
			,ST.[SubjectType] 
			,ISNULL(SPR.[RCHID] ,'') AS RCHID
			,SP.[Age] 
			,SP.[Gender] 
			,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB
			,SP.[MobileNo] AS ContactNo
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
				CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			  (SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			 ('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
			 CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore
			,ISNULL(SPR.[ECNumber],'') AS ECNumber
			,SD.[BarcodeNo]
			,CONVERT(VARCHAR,S.[DateofShipment],103) AS ShipmentDate
			,(UM.[FirstName] + ' ' + UM.[LastName]) AS ANMName
			,DM.[Districtname]
			,CM.[CHCname] 
			,PM.[PHCname] 
			,SCM.[SCname] 
			,RI.[RIsite] AS RIPoint
			,CASE WHEN SD.[SampleDamaged] = 1 THEN 'Sample Damaged'
			WHEN SD.[SampleTimeoutExpiry] = 1 THEN 'Sample Timeout Expiry'
			WHEN CB.[BarcodeNo]  IS NULL AND SS.[BarcodeNo]  IS NULL THEN 'Pending'
			ELSE 'Tested' END AS SampleStatus
			,CB.[MCV]
			,CB.[RDW] 
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive , ' + CB.[CBCResult] WHEN SS.[IsPositive] = 0 THEN 'SST Negative , ' + CB.[CBCResult] ELSE  CB.[CBCResult] END CBCResult 
			--,CB.[CBCResult] 
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive , ' + CB.[CBCResult] WHEN SS.[IsPositive] = 0 THEN 'SST Negative , ' + CB.[CBCResult] ELSE  CB.[CBCResult] END SSTResult 
		FROM [dbo].[Tbl_ANMCHCShipments] S 
		LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK)ON CM.ID = SP.CHCID
		LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK)ON PM.ID = SP.PHCID
		LEFT JOIN [dbo].[Tbl_SCMaster] SCM WITH (NOLOCK)ON SCM.ID = SP.SCID
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON RI.ID = SP.RIID
		LEFT JOIN [dbo].[Tbl_UserMaster] UM  WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID 
		LEFT JOIN [dbo].[Tbl_CBCTestResult]  CB  WITH (NOLOCK) ON CB.BarcodeNo  = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_SSTestResult]  SS  WITH (NOLOCK) ON SS.BarcodeNo  = SD.BarcodeNo 
		WHERE  S.[TestingCHCID] = @TestingCHCId   
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID) 
		AND (CONVERT(DATE,S.[DateofShipment],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
	END
	IF @StatusName =  'Samples Received'
	BEGIN
		SELECT SP.[ID] AS SubjectId
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
			,SD.[UniqueSubjectID]
			,ST.[SubjectType] 
			,ISNULL(SPR.[RCHID] ,'') AS RCHID
			,SP.[Age] 
			,SP.[Gender] 
			,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB
			,SP.[MobileNo] AS ContactNo
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
				CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			  (SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			 ('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
			 CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore
			,ISNULL(SPR.[ECNumber],'') AS ECNumber
			,SD.[BarcodeNo]
			,CONVERT(VARCHAR,S.[DateofShipment],103) AS ShipmentDate
			,(UM.[FirstName] + ' ' + UM.[LastName]) AS ANMName
			,DM.[Districtname]
			,CM.[CHCname] 
			,PM.[PHCname] 
			,SCM.[SCname] 
			,RI.[RIsite] AS RIPoint
			,CASE WHEN SD.[SampleDamaged] = 1 THEN 'Sample Damaged'
			WHEN SD.[SampleTimeoutExpiry] = 1 THEN 'Sample Timeout Expiry'
			WHEN CB.[BarcodeNo]  IS NULL AND SS.[BarcodeNo]  IS NULL THEN 'Pending'
			ELSE 'Tested' END AS SampleStatus
			,CB.[MCV]
			,CB.[RDW] 
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive , ' + CB.[CBCResult] WHEN SS.[IsPositive] = 0 THEN 'SST Negative , ' + CB.[CBCResult] ELSE  CB.[CBCResult] END CBCResult 
			--,CB.[CBCResult] 
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive , ' + CB.[CBCResult] WHEN SS.[IsPositive] = 0 THEN 'SST Negative , ' + CB.[CBCResult] ELSE  CB.[CBCResult] END SSTResult  
		FROM [dbo].[Tbl_ANMCHCShipments] S 
		LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK)ON CM.ID = SP.CHCID
		LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK)ON PM.ID = SP.PHCID
		LEFT JOIN [dbo].[Tbl_SCMaster] SCM WITH (NOLOCK)ON SCM.ID = SP.SCID
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON RI.ID = SP.RIID
		LEFT JOIN [dbo].[Tbl_UserMaster] UM  WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID 
		LEFT JOIN [dbo].[Tbl_CBCTestResult]  CB  WITH (NOLOCK) ON CB.BarcodeNo  = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_SSTestResult]  SS  WITH (NOLOCK) ON SS.BarcodeNo  = SD.BarcodeNo
		WHERE  S.[ReceivedDate] IS NOT NULL AND S.[TestingCHCID] = @TestingCHCId   
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID) 
		AND (CONVERT(DATE,S.[DateofShipment],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
	END
	
	IF @StatusName =  'Samples Discarded'
	BEGIN
		SELECT SP.[ID] AS SubjectId
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
			,SD.[UniqueSubjectID]
			,ST.[SubjectType] 
			,ISNULL(SPR.[RCHID] ,'') AS RCHID
			,SP.[Age] 
			,SP.[Gender] 
			,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB
			,SP.[MobileNo] AS ContactNo
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
				CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			 (SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			 ('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
			 CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore
			,ISNULL(SPR.[ECNumber],'') AS ECNumber
			,SD.[BarcodeNo]
			,CONVERT(VARCHAR,S.[DateofShipment],103) AS ShipmentDate
			,(UM.[FirstName] + ' ' + UM.[LastName]) AS ANMName
			,DM.[Districtname]
			,CM.[CHCname] 
			,PM.[PHCname] 
			,SCM.[SCname] 
			,RI.[RIsite] AS RIPoint
			,CASE WHEN SD.[SampleDamaged] = 1 THEN 'Sample Damaged'
			WHEN SD.[SampleTimeoutExpiry] = 1 THEN 'Sample Timeout Expiry'
			 END AS SampleStatus
			,CB.[MCV]
			,CB.[RDW] 
			,CB.[CBCResult]
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive' WHEN SS.[IsPositive] = 0 THEN 'SST Negative' ELSE NULL END SSTResult 
		FROM [dbo].[Tbl_ANMCHCShipments] S 
		LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK)ON CM.ID = SP.CHCID
		LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK)ON PM.ID = SP.PHCID
		LEFT JOIN [dbo].[Tbl_SCMaster] SCM WITH (NOLOCK)ON SCM.ID = SP.SCID
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON RI.ID = SP.RIID
		LEFT JOIN [dbo].[Tbl_UserMaster] UM  WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID 
		LEFT JOIN [dbo].[Tbl_CBCTestResult]  CB  WITH (NOLOCK) ON CB.BarcodeNo  = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_SSTestResult]  SS  WITH (NOLOCK) ON SS.BarcodeNo  = SD.BarcodeNo
		 
		WHERE  S.[TestingCHCID] = @TestingCHCId   
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID) AND SD.[BarcodeNo] NOT IN (SELECT BarcodeNo FROM Tbl_HPLCTestResult)
		AND (SD.[SampleDamaged] = 1 OR SD.[SampleTimeoutExpiry] = 1)
		AND (CONVERT(DATE,S.[DateofShipment],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103))  
	END
	
	IF @StatusName =  'CBC Tested Samples'
	BEGIN
		SELECT SP.[ID] AS SubjectId
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
			,SD.[UniqueSubjectID]
			,ST.[SubjectType] 
			,ISNULL(SPR.[RCHID] ,'') AS RCHID
			,SP.[Age] 
			,SP.[Gender] 
			,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB
			,SP.[MobileNo] AS ContactNo
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
				CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			  (SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			 ('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
			 CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore
			,ISNULL(SPR.[ECNumber],'') AS ECNumber
			,SD.[BarcodeNo]
			,CONVERT(VARCHAR,S.[DateofShipment],103) AS ShipmentDate
			,(UM.[FirstName] + ' ' + UM.[LastName]) AS ANMName
			,DM.[Districtname]
			,CM.[CHCname] 
			,PM.[PHCname] 
			,SCM.[SCname] 
			,RI.[RIsite] AS RIPoint
			,'Tested'  AS SampleStatus
			,CB.[MCV]
			,CB.[RDW] 
			,CB.[CBCResult]
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive' WHEN SS.[IsPositive] = 0 THEN 'SST Negative' ELSE NULL END SSTResult 
		FROM [dbo].[Tbl_CBCTestResult] CB
		LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.BarcodeNo = CB.BarcodeNo
		LEFT JOIN [dbo].[Tbl_ANMCHCShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SSTestResult]  SS WITH (NOLOCK) ON SD.BarcodeNo = SS.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK)ON CM.ID = SP.CHCID
		LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK)ON PM.ID = SP.PHCID
		LEFT JOIN [dbo].[Tbl_SCMaster] SCM WITH (NOLOCK)ON SCM.ID = SP.SCID
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON RI.ID = SP.RIID
		LEFT JOIN [dbo].[Tbl_UserMaster] UM  WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID 
		WHERE S.[TestingCHCID] = @TestingCHCId   
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID) 
		AND (CONVERT(DATE,CB.[TestCompleteOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 

	END
	
	IF @StatusName =  'CBC Positive Subjects'
	BEGIN
		SELECT SP.[ID] AS SubjectId
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
			,SD.[UniqueSubjectID]
			,ST.[SubjectType] 
			,ISNULL(SPR.[RCHID] ,'') AS RCHID
			,SP.[Age] 
			,SP.[Gender] 
			,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB
			,SP.[MobileNo] AS ContactNo
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
				CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			  (SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			 ('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
			 CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore
			,ISNULL(SPR.[ECNumber],'') AS ECNumber
			,SD.[BarcodeNo]
			,CONVERT(VARCHAR,S.[DateofShipment],103) AS ShipmentDate
			,(UM.[FirstName] + ' ' + UM.[LastName]) AS ANMName
			,DM.[Districtname]
			,CM.[CHCname] 
			,PM.[PHCname] 
			,SCM.[SCname] 
			,RI.[RIsite] AS RIPoint
			,CASE WHEN CB.[IsPositive] = 1 THEN 'Positive'
			ELSE 'Negative' END AS SampleStatus
			,CB.[MCV]
			,CB.[RDW] 
			,CB.[CBCResult]
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive' WHEN SS.[IsPositive] = 0 THEN 'SST Negative' ELSE NULL END SSTResult 
		FROM [dbo].[Tbl_CBCTestResult] CB 
		LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.BarcodeNo = CB.BarcodeNo
		LEFT JOIN [dbo].[Tbl_ANMCHCShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SSTestResult]  SS WITH (NOLOCK) ON SD.BarcodeNo = SS.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK)ON CM.ID = SP.CHCID
		LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK)ON PM.ID = SP.PHCID
		LEFT JOIN [dbo].[Tbl_SCMaster] SCM WITH (NOLOCK)ON SCM.ID = SP.SCID
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON RI.ID = SP.RIID
		LEFT JOIN [dbo].[Tbl_UserMaster] UM  WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID 
		WHERE S.[TestingCHCID] = @TestingCHCId AND CB.[IsPositive]  = 1
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID) 
		AND (CONVERT(DATE,CB.[TestCompleteOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
	END
	
	IF @StatusName =  'SST Tested Samples'
	BEGIN
		SELECT SP.[ID] AS SubjectId
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
			,SD.[UniqueSubjectID]
			,ST.[SubjectType] 
			,ISNULL(SPR.[RCHID] ,'') AS RCHID
			,SP.[Age] 
			,SP.[Gender] 
			,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB
			,SP.[MobileNo] AS ContactNo
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
				CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			 (SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			 ('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
			 CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore
			,ISNULL(SPR.[ECNumber],'') AS ECNumber
			,SD.[BarcodeNo]
			,CONVERT(VARCHAR,S.[DateofShipment],103) AS ShipmentDate
			,(UM.[FirstName] + ' ' + UM.[LastName]) AS ANMName
			,DM.[Districtname]
			,CM.[CHCname] 
			,PM.[PHCname] 
			,SCM.[SCname] 
			,RI.[RIsite] AS RIPoint
			,'Tested'  AS SampleStatus
			,CB.[MCV]
			,CB.[RDW] 
			,CB.[CBCResult] AS SSTResult
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive' WHEN SS.[IsPositive] = 0 THEN 'SST Negative' ELSE NULL END CBCResult 
		FROM [dbo].[Tbl_SSTestResult] SS
		LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.BarcodeNo = SS.BarcodeNo
		LEFT JOIN [dbo].[Tbl_ANMCHCShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_CBCTestResult]  CB WITH (NOLOCK) ON SD.BarcodeNo = CB.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK)ON CM.ID = SP.CHCID
		LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK)ON PM.ID = SP.PHCID
		LEFT JOIN [dbo].[Tbl_SCMaster] SCM WITH (NOLOCK)ON SCM.ID = SP.SCID
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON RI.ID = SP.RIID
		LEFT JOIN [dbo].[Tbl_UserMaster] UM  WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID 
		WHERE S.[TestingCHCID] = @TestingCHCId   
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID) 
		AND (CONVERT(DATE,SS.[CreatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 

	END
	
	IF @StatusName =  'SST Positive Subjects'
	BEGIN
		SELECT SP.[ID] AS SubjectId
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
			,SD.[UniqueSubjectID]
			,ST.[SubjectType] 
			,ISNULL(SPR.[RCHID] ,'') AS RCHID
			,SP.[Age] 
			,SP.[Gender] 
			,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB
			,SP.[MobileNo] AS ContactNo
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
				CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			 (SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge
			,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			 ('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
			 CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore
			,ISNULL(SPR.[ECNumber],'') AS ECNumber
			,SD.[BarcodeNo]
			,CONVERT(VARCHAR,S.[DateofShipment],103) AS ShipmentDate
			,(UM.[FirstName] + ' ' + UM.[LastName]) AS ANMName
			,DM.[Districtname]
			,CM.[CHCname] 
			,PM.[PHCname] 
			,SCM.[SCname] 
			,RI.[RIsite] AS RIPoint
			,CASE WHEN SS.[IsPositive] = 1 THEN 'Positive'
			ELSE 'Negative' END AS SampleStatus
			,CB.[MCV]
			,CB.[RDW] 
			,CB.[CBCResult] AS SSTResult
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive' WHEN SS.[IsPositive] = 0 THEN 'SST Negative' ELSE NULL END CBCResult 
		FROM [dbo].[Tbl_SSTestResult] SS 
		LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.BarcodeNo = SS.BarcodeNo
		LEFT JOIN [dbo].[Tbl_ANMCHCShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_CBCTestResult]  CB WITH (NOLOCK) ON SD.BarcodeNo = CB.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK)ON CM.ID = SP.CHCID
		LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK)ON PM.ID = SP.PHCID
		LEFT JOIN [dbo].[Tbl_SCMaster] SCM WITH (NOLOCK)ON SCM.ID = SP.SCID
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON RI.ID = SP.RIID
		LEFT JOIN [dbo].[Tbl_UserMaster] UM  WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID 
		WHERE S.[TestingCHCID] = @TestingCHCId AND SS.[IsPositive]  = 1
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID) 
		AND (CONVERT(DATE,SS.[CreatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
	END
END