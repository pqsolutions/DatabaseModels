USE Eduquaydb
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMolecularTestReports' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMolecularTestReports 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMolecularTestReports] 
(
	@SampleStatus INT
	,@MolecularLabId INT
	,@DistrictId INT
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
	SET  @StatusName = (SELECT StatusName FROM Tbl_MolecularSampleStatusMaster WHERE ID = @SampleStatus)
	
	IF @StatusName =  'Test Pending' 
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
			,DM.[Districtname]
			,CONVERT(VARCHAR,S.[DateofShipment],103) AS ShipmentDate
			,'Pending' AS SampleStatus
			,NULL AS Diagnosis
			,NULL AS MolecularResult
			,0 AS Processed
			,0 AS Damaged
		FROM [dbo].[Tbl_CentralLabShipments] S 
		LEFT JOIN [dbo].[Tbl_CentralLabShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.[ChildSubjectTypeID] 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
		WHERE S.[ReceivedDate] IS NOT NULL AND S.[ReceivingMolecularLabId] = @MolecularLabId 
		AND SD.[BarcodeNo]   NOT IN (SELECT BarcodeNo FROM Tbl_MolecularTestResult)
		AND (@DistrictId = 0 OR SP.[DistrictID] = @DistrictId)
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID) 
		AND (CONVERT(DATE,S.[DateofShipment],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		
	END
	IF @StatusName =  'Test Completed' OR @SampleStatus = 0
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
			,DM.[Districtname]
			,CONVERT(VARCHAR,S.[DateofShipment],103) AS ShipmentDate
			,'Processed' AS SampleStatus
			,CASE WHEN MR.[IsProcessed] = 1 THEN CDM.[DiagnosisName] ELSE NULL END AS Diagnosis
			,CASE WHEN MR.[IsProcessed] = 1 THEN MRM.[ResultName]  ELSE NULL END AS MolecularResult
			,ISNULL(IsProcessed,0) AS Processed
			,ISNULL(IsDamaged,0) AS Damaged
			
		FROM [dbo].[Tbl_MolecularTestResult] MR
		LEFT JOIN [dbo].[Tbl_CentralLabShipmentsDetail]  SD WITH (NOLOCK) ON SD.BarcodeNo = MR.BarcodeNo
		LEFT JOIN [dbo].[Tbl_CentralLabShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
		LEFT JOIN [dbo].[Tbl_ClinicalDiagnosisMaster] CDM WITH (NOLOCK) ON MR.ClinicalDiagnosisId = CDM.ID 
		LEFT JOIN [dbo].[Tbl_MolecularResultMaster] MRM WITH (NOLOCK) ON MR.Result  = MRM.ID 	
		WHERE  S.[ReceivingMolecularLabId] = @MolecularLabId 
		AND (@DistrictId = 0 OR SP.[DistrictID] = @DistrictId)
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID)
		AND (CONVERT(DATE,MR.[UpdatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		
	END
	IF @StatusName =  'DNA Positive'
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
			,DM.[Districtname]
			,CONVERT(VARCHAR,S.[DateofShipment],103) AS ShipmentDate
			,MRM.[ResultName] AS SampleStatus
			,CASE WHEN MR.[IsProcessed] = 1 THEN CDM.[DiagnosisName] ELSE NULL END AS Diagnosis
			,CASE WHEN MR.[IsProcessed] = 1 THEN MRM.[ResultName]  ELSE NULL END AS MolecularResult
			,IsProcessed AS Processed
			,IsDamaged AS Damaged
			
		FROM [dbo].[Tbl_MolecularTestResult] MR
		LEFT JOIN [dbo].[Tbl_CentralLabShipmentsDetail]  SD WITH (NOLOCK) ON SD.BarcodeNo = MR.BarcodeNo
		LEFT JOIN [dbo].[Tbl_CentralLabShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.[ChildSubjectTypeID] 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
		LEFT JOIN [dbo].[Tbl_ClinicalDiagnosisMaster] CDM WITH (NOLOCK) ON MR.ClinicalDiagnosisId = CDM.ID 
		LEFT JOIN [dbo].[Tbl_MolecularResultMaster] MRM WITH (NOLOCK) ON MR.Result  = MRM.ID 
		WHERE  S.[ReceivingMolecularLabId] = @MolecularLabId 
		AND MR.[Result] = (SELECT ID FROM Tbl_MolecularResultMaster WHERE ResultName = 'DNA Test Positive') 
		AND (@DistrictId = 0 OR SP.[DistrictID] = @DistrictId)
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID)
		AND (CONVERT(DATE,MR.[UpdatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		
	END
	
	IF @StatusName =  'Normal'
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
			,DM.[Districtname]
			,CONVERT(VARCHAR,S.[DateofShipment],103) AS ShipmentDate
			,MRM.[ResultName] AS SampleStatus
			,CASE WHEN MR.[IsProcessed] = 1 THEN CDM.[DiagnosisName] ELSE NULL END AS Diagnosis
			,CASE WHEN MR.[IsProcessed] = 1 THEN MRM.[ResultName]  ELSE NULL END AS MolecularResult
			,IsProcessed AS Processed
			,IsDamaged AS Damaged
		FROM [dbo].[Tbl_MolecularTestResult] MR
		LEFT JOIN [dbo].[Tbl_CentralLabShipmentsDetail]  SD WITH (NOLOCK) ON SD.BarcodeNo = MR.BarcodeNo
		LEFT JOIN [dbo].[Tbl_CentralLabShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.[ChildSubjectTypeID] 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
		LEFT JOIN [dbo].[Tbl_ClinicalDiagnosisMaster] CDM WITH (NOLOCK) ON MR.ClinicalDiagnosisId = CDM.ID 
		LEFT JOIN [dbo].[Tbl_MolecularResultMaster] MRM WITH (NOLOCK) ON MR.Result  = MRM.ID 
		WHERE  S.[ReceivingMolecularLabId] = @MolecularLabId 
		AND MR.[Result] = (SELECT ID FROM Tbl_MolecularResultMaster WHERE ResultName = 'Normal') 
		AND (@DistrictId = 0 OR SP.[DistrictID] = @DistrictId)
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID)
		AND (CONVERT(DATE,MR.[UpdatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		
	END
	
	IF @StatusName =  'Damaged & Processed'
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
			,DM.[Districtname]
			,CONVERT(VARCHAR,S.[DateofShipment],103) AS ShipmentDate
			,'Damaged & Processed' AS SampleStatus
			,CASE WHEN MR.[IsProcessed] = 1 THEN CDM.[DiagnosisName] ELSE NULL END AS Diagnosis
			,CASE WHEN MR.[IsProcessed] = 1 THEN MRM.[ResultName]  ELSE NULL END AS MolecularResult
			,IsProcessed AS Processed
			,IsDamaged AS Damaged
		FROM [dbo].[Tbl_MolecularTestResult] MR
		LEFT JOIN [dbo].[Tbl_CentralLabShipmentsDetail]  SD WITH (NOLOCK) ON SD.BarcodeNo = MR.BarcodeNo
		LEFT JOIN [dbo].[Tbl_CentralLabShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.[ChildSubjectTypeID] 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
		LEFT JOIN [dbo].[Tbl_ClinicalDiagnosisMaster] CDM WITH (NOLOCK) ON MR.ClinicalDiagnosisId = CDM.ID 
		LEFT JOIN [dbo].[Tbl_MolecularResultMaster] MRM WITH (NOLOCK) ON MR.Result  = MRM.ID
		WHERE  S.[ReceivingMolecularLabId] = @MolecularLabId 
		AND MR.[IsDamaged] = 1 AND MR.[IsProcessed] = 1
		AND (@DistrictId = 0 OR SP.[DistrictID] = @DistrictId)
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID)
		AND (CONVERT(DATE,MR.[UpdatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		
	END
	
	IF @StatusName =  'Damaged & Unprocessed'
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
			,DM.[Districtname]
			,CONVERT(VARCHAR,S.[DateofShipment],103) AS ShipmentDate
			,'Damaged & Unprocessed' AS SampleStatus
			,CASE WHEN MR.[IsProcessed] = 1 THEN CDM.[DiagnosisName] ELSE NULL END AS Diagnosis
			,CASE WHEN MR.[IsProcessed] = 1 THEN MRM.[ResultName]  ELSE NULL END AS MolecularResult
			,IsProcessed AS Processed
			,ISNULL(IsDamaged,0) AS Damaged
		FROM [dbo].[Tbl_MolecularTestResult] MR
		LEFT JOIN [dbo].[Tbl_CentralLabShipmentsDetail]  SD WITH (NOLOCK) ON SD.BarcodeNo = MR.BarcodeNo
		LEFT JOIN [dbo].[Tbl_CentralLabShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.[ChildSubjectTypeID] 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
		LEFT JOIN [dbo].[Tbl_ClinicalDiagnosisMaster] CDM WITH (NOLOCK) ON MR.ClinicalDiagnosisId = CDM.ID 
		LEFT JOIN [dbo].[Tbl_MolecularResultMaster] MRM WITH (NOLOCK) ON MR.Result  = MRM.ID
		WHERE  S.[ReceivingMolecularLabId] = @MolecularLabId 
		AND MR.[IsDamaged] = 1 AND MR.[IsProcessed] = 0
		AND (@DistrictId = 0 OR SP.[DistrictID] = @DistrictId)
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID) 
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID) 
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID)
		AND (CONVERT(DATE,MR.[UpdatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		
	END
	
END