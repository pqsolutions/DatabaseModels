--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCentralLabStatusReports' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCentralLabStatusReports
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchCentralLabStatusReports] 
(
	@SampleStatus INT
	,@CentralLabId INT
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
		SET @StartDate = (SELECT CONVERT(VARCHAR,DATEADD(MONTH ,-3,GETDATE()),103))
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
	SET  @StatusName = (SELECT StatusName FROM Tbl_CentralLabSampleStatusMaster WHERE ID = @SampleStatus)
	
	IF @StatusName =  'Samples Shipped To Molecular Lab'
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
			,'Shipped'  AS SampleStatus
			,ISNULL(HT.[HPLCResult],'') AS Result
			,HT.[HbA0]
			,HT.[HbA2]
			,HT.[HbC]
			,HT.[HbD]
			,HT.[HbF]
			,HT.[HbS] 
			,HT.[LabDiagnosis] AS [DiagnosisName]
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive' WHEN SS.[IsPositive] = 0 THEN 'SST Negative' END AS SSTResult
			,CB.[MCV]
			,CB.[RDW] 
			,CB.[RBC]
			,CB.[CBCResult]
			,HTD.[PdfFileName]  
		FROM [dbo].[Tbl_CentralLabShipments] S 
		LEFT JOIN [dbo].[Tbl_CentralLabShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK)ON CM.ID = SP.CHCID
		LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK)ON PM.ID = SP.PHCID
		LEFT JOIN [dbo].[Tbl_SCMaster] SCM WITH (NOLOCK)ON SCM.ID = SP.SCID
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON RI.ID = SP.RIID
		LEFT JOIN [dbo].[Tbl_CBCTestResult]  CB  WITH (NOLOCK) ON CB.BarcodeNo  = SC.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_SSTestResult]  SS  WITH (NOLOCK) ON SS.BarcodeNo  = SC.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_UserMaster] UM  WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID 
		LEFT JOIN [dbo].[Tbl_HPLCTestResult] HT WITH (NOLOCK) ON HT.BarcodeNo = SD.BarcodeNo
		LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult]   HD WITH (NOLOCK) ON HD.BarcodeNo = HT.BarcodeNo
		LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD WITH (NOLOCK) ON  HT.BarcodeNo = HTD.Barcode 
		WHERE  HT.[CentralLabId] = @CentralLabId 
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID) 
		AND (CONVERT(DATE,SP.[DateofRegister],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		--AND (CONVERT(DATE,S.[DateofShipment],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103))
		AND HTD.[ProcessStatus] = 1  AND HTD.[SampleStatus] = 1
	END
	IF @StatusName =  'Samples Received'  OR @SampleStatus = 0
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
			WHEN HT.[IsNormal] IS NULL THEN 'Pending'
			ELSE 'Tested' END AS SampleStatus
			,ISNULL(HT.[HPLCResult],'') AS Result
			,HT.[HbA0]
			,HT.[HbA2]
			,HT.[HbC]
			,HT.[HbD]
			,HT.[HbF]
			,HT.[HbS] 
			,HT.[LabDiagnosis] AS [DiagnosisName]
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive' WHEN SS.[IsPositive] = 0 THEN 'SST Negative' END AS SSTResult
			,CB.[MCV]
			,CB.[RDW] 
			,CB.[RBC]
			,CB.[CBCResult]
			,CASE WHEN HT.[ID] IS NULL THEN '' ELSE HTD.[PdfFileName] END AS [PdfFileName] 
		FROM [dbo].[Tbl_CHCShipments] S 
		LEFT JOIN [dbo].[Tbl_CHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
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
		LEFT JOIN [dbo].[Tbl_CBCTestResult]  CB  WITH (NOLOCK) ON CB.BarcodeNo  = SC.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_SSTestResult]  SS  WITH (NOLOCK) ON SS.BarcodeNo  = SC.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_HPLCTestResult] HT WITH (NOLOCK) ON HT.BarcodeNo = SD.BarcodeNo
		LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult]   HD WITH (NOLOCK) ON HD.BarcodeNo = HT.BarcodeNo
		LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD WITH (NOLOCK) ON  HT.BarcodeNo = HTD.Barcode AND  HTD.[ProcessStatus] = 1  AND HTD.[SampleStatus] = 1
		WHERE  S.[ReceivedDate] IS NOT NULL AND S.[ReceivingCentralLabId] = @CentralLabId 
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID)
		AND (CONVERT(DATE,SP.[DateofRegister],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		--AND (CONVERT(DATE,S.[DateofShipment],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
	END
	IF @StatusName =  'Samples Tested'
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
			,CASE WHEN HT.[IsNormal] IS NULL THEN 'Pending'
			 WHEN HT.[IsNormal] = 1 THEN 'Normal'
			ELSE 'Abnormal' END AS SampleStatus
			,ISNULL(HT.[HPLCResult],'') AS Result
			,HT.[HbA0]
			,HT.[HbA2]
			,HT.[HbC]
			,HT.[HbD]
			,HT.[HbF]
			,HT.[HbS] 
			,HT.[LabDiagnosis] AS [DiagnosisName]
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive' WHEN SS.[IsPositive] = 0 THEN 'SST Negative' END AS SSTResult
			,CB.[MCV]
			,CB.[RDW] 
			,CB.[RBC]
			,CB.[CBCResult]
			,HTD.[PdfFileName]  
		FROM [dbo].[Tbl_HPLCTestResult] HT
		LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult]   HD WITH (NOLOCK) ON HD.BarcodeNo = HT.BarcodeNo
		LEFT JOIN [dbo].[Tbl_CHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.BarcodeNo = HT.BarcodeNo
		LEFT JOIN [dbo].[Tbl_CHCShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
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
		LEFT JOIN [dbo].[Tbl_CBCTestResult]  CB  WITH (NOLOCK) ON CB.BarcodeNo  = SC.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_SSTestResult]  SS  WITH (NOLOCK) ON SS.BarcodeNo  = SC.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD WITH (NOLOCK) ON  HT.BarcodeNo = HTD.Barcode  
		WHERE HT.[CentralLabId] = @CentralLabId 
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID) 
		AND (CONVERT(DATE,SP.[DateofRegister],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		--AND (CONVERT(DATE,HT.[HPLCTestCompletedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		AND HTD.[ProcessStatus] = 1  AND HTD.[SampleStatus] = 1
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
			,ISNULL(HT.[HPLCResult],'') AS Result
			,HT.[HbA0]
			,HT.[HbA2]
			,HT.[HbC]
			,HT.[HbD]
			,HT.[HbF]
			,HT.[HbS] 
			,HT.[LabDiagnosis] AS [DiagnosisName]
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive' WHEN SS.[IsPositive] = 0 THEN 'SST Negative' END AS SSTResult
			,CB.[MCV]
			,CB.[RDW] 
			,CB.[RBC]
			,CB.[CBCResult]
			,'' AS [PdfFileName]
		FROM [dbo].[Tbl_CHCShipments] S 
		LEFT JOIN [dbo].[Tbl_CHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
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
		LEFT JOIN [dbo].[Tbl_HPLCTestResult] HT WITH (NOLOCK) ON HT.BarcodeNo = SD.BarcodeNo
		LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult]   HD WITH (NOLOCK) ON HD.BarcodeNo = HT.BarcodeNo
		LEFT JOIN [dbo].[Tbl_CBCTestResult]  CB  WITH (NOLOCK) ON CB.BarcodeNo  = SC.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_SSTestResult]  SS  WITH (NOLOCK) ON SS.BarcodeNo  = SC.BarcodeNo 
		WHERE  HT.[CentralLabId] = @CentralLabId 
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID) AND SD.[BarcodeNo] NOT IN (SELECT BarcodeNo FROM Tbl_HPLCTestResult)
		AND (SD.[SampleDamaged] = 1 OR SD.[SampleTimeoutExpiry] = 1)
		AND (CONVERT(DATE,SP.[DateofRegister],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		--AND (CONVERT(DATE,S.[DateofShipment],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103))  
	END
	IF @StatusName =  'HPLC Positive Subjects'
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
			,CASE WHEN HT.[IsNormal] = 1 THEN 'Normal'
			ELSE 'Abnormal' END AS SampleStatus
			,ISNULL(HT.[HPLCResult],'') AS Result
			,HT.[HbA0]
			,HT.[HbA2]
			,HT.[HbC]
			,HT.[HbD]
			,HT.[HbF]
			,HT.[HbS] 
			,HT.[LabDiagnosis] AS [DiagnosisName]
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive' WHEN SS.[IsPositive] = 0 THEN 'SST Negative' END AS SSTResult
			,CB.[MCV]
			,CB.[RDW] 
			,CB.[RBC]
			,CB.[CBCResult]
			,HTD.[PdfFileName] 
		FROM [dbo].[Tbl_HPLCTestResult] HT
		LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult]   HD WITH (NOLOCK) ON HD.BarcodeNo = HT.BarcodeNo
		LEFT JOIN [dbo].[Tbl_CHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.BarcodeNo = HT.BarcodeNo
		LEFT JOIN [dbo].[Tbl_CHCShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
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
		LEFT JOIN [dbo].[Tbl_CBCTestResult]  CB  WITH (NOLOCK) ON CB.BarcodeNo  = SC.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_SSTestResult]  SS  WITH (NOLOCK) ON SS.BarcodeNo  = SC.BarcodeNo
		LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD WITH (NOLOCK) ON  HT.BarcodeNo = HTD.Barcode  
		WHERE HT.[CentralLabId] = @CentralLabId AND HT.[IsPositive] = 1
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID) 
		AND (CONVERT(DATE,SP.[DateofRegister],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		--AND (CONVERT(DATE,HT.[HPLCResultUpdatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		AND HTD.[ProcessStatus] = 1  AND HTD.[SampleStatus] = 1
	END
	IF @StatusName =  'HPLC Negative Subjects'
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
			,CASE WHEN HT.[IsNormal] = 1 THEN 'Normal'
			ELSE 'Abnormal' END AS SampleStatus
			,ISNULL(HT.[HPLCResult],'') AS Result
			,HT.[HbA0]
			,HT.[HbA2]
			,HT.[HbC]
			,HT.[HbD]
			,HT.[HbF]
			,HT.[HbS] 
			,HT.[LabDiagnosis] AS [DiagnosisName]
			,CASE WHEN SS.[IsPositive] = 1 THEN 'SST Positive' WHEN SS.[IsPositive] = 0 THEN 'SST Negative' END AS SSTResult
			,CB.[MCV]
			,CB.[RDW] 
			,CB.[RBC]
			,CB.[CBCResult]
			,HTD.[PdfFileName]
		FROM [dbo].[Tbl_HPLCTestResult] HT
		LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult]   HD WITH (NOLOCK) ON HD.BarcodeNo = HT.BarcodeNo
		LEFT JOIN [dbo].[Tbl_CHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.BarcodeNo = HT.BarcodeNo
		LEFT JOIN [dbo].[Tbl_CHCShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
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
		LEFT JOIN [dbo].[Tbl_CBCTestResult]  CB  WITH (NOLOCK) ON CB.BarcodeNo  = SC.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_SSTestResult]  SS  WITH (NOLOCK) ON SS.BarcodeNo  = SC.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD WITH (NOLOCK) ON  HT.BarcodeNo = HTD.Barcode  
		WHERE HT.[CentralLabId] = @CentralLabId AND HT.[IsPositive] = 0
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID) 
		AND (CONVERT(DATE,SP.[DateofRegister],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		--AND (CONVERT(DATE,HT.[HPLCResultUpdatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		AND HTD.[ProcessStatus] = 1  AND HTD.[SampleStatus] = 1
	END
END