--USE Eduquaydb
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchPathoDiagnosisReports' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchPathoDiagnosisReports --0,1,0,0,0,'',''
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchPathoDiagnosisReports] 
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
	SET  @StatusName = (SELECT StatusName FROM Tbl_PathologistSampleStatusMaster WHERE ID = @SampleStatus)
	IF @StatusName =  'All' OR @SampleStatus = 0
	BEGIN
		 SELECT SP.[ID] AS SubjectId  
		   ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName  
		   ,(SP.[Spouse_FirstName] + ' ' + SP.[Spouse_MiddleName] + ' ' + SP.[Spouse_LastName]) AS SpouseName  
		   ,HT.[UniqueSubjectID]  
		   ,ST.[SubjectType]   
		   ,ISNULL(SPR.[RCHID] ,'') AS RCHID  
		   ,SP.[Age]   
		   ,SP.[Gender]  
		   ,(SPA.[Address2] + ' ' +SPA.[Address3]) AS SubjectAddress  
		   ,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB  
		   ,SP.[MobileNo] AS ContactNo  
		   ,SP.[Spouse_ContactNo] AS SpouseContactNo  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
			CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
		   (SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
			('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+  
			CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore  
		   ,ISNULL(SPR.[ECNumber],'') AS ECNumber  
		   ,HT.[BarcodeNo]  
		   ,DM.[Districtname]  
		   ,CHC.[CHCname]  
		   ,B.[Blockname]  
		   ,SCM.[SCname]  
		   ,PHC.[PHCname]  
		   ,RI.[RIsite] AS RIPoint  
		   ,CASE WHEN  HD.[IsDiagnosisComplete] = 1  THEN  'Completed'  ELSE 'Pending' END  AS SampleStatus  
		   ,CBC.[CBCResult]  
		   ,CBC.[MCV]  
		   ,CBC.[RDW]  
		   ,CBC.[RBC]  
		   ,CASE WHEN SST.[IsPositive] =  1 THEN 'Positive' ELSE 'Negative' END SSTResult  
		   ,HT.[HPLCResult]  
		   ,HT.[HbF]  
		   ,HT.[HbA0]  
		   ,HT.[HbA2]  
		   ,HT.[HbS]  
		   ,HT.[HbD]  
		   ,HT.[LabDiagnosis]  
		   ,HTD.[PdfFileName]  
		   ,HD.[SeniorPathologistRemarks]  
		   ,HD.[DiagnosisSummary]  
		   ,(U.[FirstName] + ' '  + U.[LastName]) AS ANMName  
		   ,CASE WHEN HT.[HPLCResultUpdatedOn] IS NULL THEN ' '  
		   ELSE (CONVERT(VARCHAR,HT.[HPLCResultUpdatedOn],103) + ' ' + CONVERT(VARCHAR(5),HT.[HPLCResultUpdatedOn],108)) END AS DiagnosisDateTime  
		   ,CONVERT(VARCHAR,SP.[DateofRegister],103) AS DateOfRegister
		   ,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) AS SampleCollectionDate
		   ,'TSCOD PROGRAM' AS ReferringDepartment
		   ,'Dr. Alok Srivastava' AS OrderingPhysician
		   ,(LTUM.[FirstName] + ' ' + LTUM.[LastName]) AS LabTechnicianName
		   --,'Mr. Solomon Ekka' AS LabTechnicianName
		   --,(PUM.[FirstName] + ' ' + PUM.[LastName]) AS PathologistName
		   ,'Dr. Sreeya Das' AS PathologistName
		FROM [dbo].[Tbl_PositiveResultSubjectsDetail] PRSD 
		LEFT JOIN  [dbo].[Tbl_HPLCTestResult] HT WITH (NOLOCK) ON PRSD.BarcodeNo = HT.BarcodeNo
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = HT.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_CBCTestResult] CBC WITH (NOLOCK) ON CBC.BarcodeNo = PRSD.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SSTestResult] SST WITH (NOLOCK) ON SST.BarcodeNo = PRSD.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = PRSD.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = PRSD.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SPA   WITH (NOLOCK) ON SPA.UniqueSubjectID = PRSD.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID   
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID  
		LEFT JOIN [dbo].[Tbl_CHCMaster] CHC WITH (NOLOCK)ON  CHC.ID = SP.CHCID  
		LEFT JOIN [dbo].[Tbl_PHCMaster] PHC WITH (NOLOCK)ON  PHC.ID = SP.PHCID  
		LEFT JOIN [dbo].[Tbl_BlockMaster] B WITH (NOLOCK)ON  CHC.BlockID = B.ID  
		LEFT JOIN [dbo].[Tbl_SCMaster] SCM WITH (NOLOCK)ON  SCM.ID = SP.SCID  
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON  RI.ID = SP.RIID  
		LEFT JOIN [dbo].[Tbl_UserMaster] U WITH (NOLOCK) ON U.ID = SP.AssignANM_ID  
		LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD WITH (NOLOCK) ON  HT.BarcodeNo = HTD.Barcode  
		LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON  HD.BarcodeNo = PRSD.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_UserMaster] LTUM WITH (NOLOCK) ON LTUM.ID = HT.CreatedBy
		LEFT JOIN [dbo].[Tbl_UserMaster] PUM WITH (NOLOCK) ON PUM.ID = HD.CreatedBy
		WHERE  HT.[CentralLabId] = @CentralLabId   
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID)   
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID)   
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID)   
		AND (CONVERT(DATE,HT.[HPLCTestCompletedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103))
		AND HTD.[ProcessStatus] = 1  AND HTD.[SampleStatus] = 1
	END  
	IF @StatusName =  'Diagnosis Pending'   
	BEGIN  
		SELECT SP.[ID] AS SubjectId  
		   ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName  
		   ,(SP.[Spouse_FirstName] + ' ' + SP.[Spouse_MiddleName] + ' ' + SP.[Spouse_LastName]) AS SpouseName  
		   ,HT.[UniqueSubjectID]  
		   ,ST.[SubjectType]   
		   ,ISNULL(SPR.[RCHID] ,'') AS RCHID  
		   ,SP.[Age]   
		   ,SP.[Gender]  
		   ,(SPA.[Address2] + ' ' +SPA.[Address3]) AS SubjectAddress  
		   ,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB  
		   ,SP.[MobileNo] AS ContactNo  
		   ,SP.[Spouse_ContactNo] AS SpouseContactNo  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
			CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
		   (SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
			('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+  
			CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore  
		   ,ISNULL(SPR.[ECNumber],'') AS ECNumber  
		   ,HT.[BarcodeNo]  
		   ,DM.[Districtname]  
		   ,CHC.[CHCname]  
		   ,B.[Blockname]  
		   ,SCM.[SCname]  
		   ,PHC.[PHCname]  
		   ,RI.[RIsite] AS RIPoint  
		   ,'Pending' AS SampleStatus  
		   ,CBC.[CBCResult]  
		   ,CBC.[MCV]  
		   ,CBC.[RDW]  
		   ,CBC.[RBC]  
		   ,CASE WHEN SST.[IsPositive] =  1 THEN 'Positive' ELSE 'Negative' END SSTResult  
		   ,HT.[HPLCResult]  
		   ,HT.[HbF]  
		   ,HT.[HbA0]  
		   ,HT.[HbA2]  
		   ,HT.[HbS]  
		   ,HT.[HbD]  
		   ,HT.[LabDiagnosis]  
		   ,HTD.[PdfFileName]  
		   , ''AS  SeniorPathologistRemarks  
		   ,'' AS  [DiagnosisSummary]  
		   ,(U.[FirstName] + ' '  + U.[LastName]) AS ANMName  
		   ,CASE WHEN HT.[HPLCResultUpdatedOn] IS NULL THEN ' '  
		   ELSE (CONVERT(VARCHAR,HT.[HPLCResultUpdatedOn],103) + ' ' + CONVERT(VARCHAR(5),HT.[HPLCResultUpdatedOn],108)) END AS DiagnosisDateTime 
		   ,CONVERT(VARCHAR,SP.[DateofRegister],103) AS DateOfRegister
		   ,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) AS SampleCollectionDate
		   ,'TSCOD PROGRAM' AS ReferringDepartment
		   ,'Dr. Alok Srivastava' AS OrderingPhysician
		   ,(LTUM.[FirstName] + ' ' + LTUM.[LastName]) AS LabTechnicianName
		   --,'Mr. Solomon Ekka' AS LabTechnicianName
		  -- ,(PUM.[FirstName] + ' ' + PUM.[LastName]) AS PathologistName
		   ,'Dr. Sreeya Das' AS PathologistName
		FROM [dbo].[Tbl_HPLCTestResult] HT   
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = HT.BarcodeNo   
		LEFT JOIN [dbo].[Tbl_CBCTestResult] CBC WITH (NOLOCK) ON CBC.BarcodeNo = HT.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SSTestResult] SST WITH (NOLOCK) ON SST.BarcodeNo = HT.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SPA   WITH (NOLOCK) ON SPA.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID   
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID  
		LEFT JOIN [dbo].[Tbl_CHCMaster] CHC WITH (NOLOCK)ON  CHC.ID = SP.CHCID  
		LEFT JOIN [dbo].[Tbl_PHCMaster] PHC WITH (NOLOCK)ON  PHC.ID = SP.PHCID  
		LEFT JOIN [dbo].[Tbl_BlockMaster] B WITH (NOLOCK)ON  CHC.BlockID = B.ID  
		LEFT JOIN [dbo].[Tbl_SCMaster] SCM WITH (NOLOCK)ON  SCM.ID = SP.SCID  
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON  RI.ID = SP.RIID  
		LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD WITH (NOLOCK) ON  HTD.Barcode = HT.[BarcodeNo]  
		LEFT JOIN [dbo].[Tbl_UserMaster] U WITH (NOLOCK) ON U.ID = SP.AssignANM_ID 
		LEFT JOIN [dbo].[Tbl_UserMaster] LTUM WITH (NOLOCK) ON LTUM.ID = HT.CreatedBy
		WHERE  HT.[CentralLabId] = @CentralLabId   
		AND HT.[BarcodeNo]   NOT IN (SELECT BarcodeNo FROM Tbl_HPLCDiagnosisResult)  
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID)   
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID)   
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID)   
		AND (CONVERT(DATE,HT.[HPLCTestCompletedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103))  
		AND HTD.[ProcessStatus] = 1  AND HTD.[SampleStatus] = 1
	END  
	IF @StatusName =  'Diagnosis Completed'   
	BEGIN  
		SELECT SP.[ID] AS SubjectId  
		   ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName  
		   ,(SP.[Spouse_FirstName] + ' ' + SP.[Spouse_MiddleName] + ' ' + SP.[Spouse_LastName]) AS SpouseName  
		   ,HT.[UniqueSubjectID]  
		   ,ST.[SubjectType]   
		   ,ISNULL(SPR.[RCHID] ,'') AS RCHID  
		   ,SP.[Age]   
		   ,SP.[Gender]  
		   ,(SPA.[Address2] + ' ' +SPA.[Address3]) AS SubjectAddress  
		   ,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB  
		   ,SP.[MobileNo] AS ContactNo  
		   ,SP.[Spouse_ContactNo] AS SpouseContactNo  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
			CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
		   (SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
			('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+  
			CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore  
		   ,ISNULL(SPR.[ECNumber],'') AS ECNumber  
		   ,HT.[BarcodeNo]  
		   ,DM.[Districtname]  
		   ,CHC.[CHCname]   
		   ,B.[Blockname]  
		   ,SCM.[SCname]  
		   ,PHC.[PHCname]  
		   ,RI.[RIsite] AS RIPoint  
		   ,CASE WHEN HD.[IsDiagnosisComplete] = 1 THEN 'Diagnosis Completed' ELSE 'Waiting for Result' END  AS SampleStatus  
		   ,CBC.[CBCResult]  
		   ,CBC.[MCV]  
		   ,CBC.[RDW]  
		   ,CBC.[RBC]  
		   ,CASE WHEN SST.[IsPositive] =  1 THEN 'Positive' ELSE 'Negative' END SSTResult  
		   ,HT.[HPLCResult]  
		   ,HT.[HbF]  
		   ,HT.[HbA0]  
		   ,HT.[HbA2]  
		   ,HT.[HbS]  
		   ,HT.[HbD]  
		   ,HT.[LabDiagnosis] AS LabDiagnosis  
		   ,HTD.[PdfFileName]  
		   ,HD.[SeniorPathologistRemarks]  
		   ,HD.[DiagnosisSummary]  
		   ,(U.[FirstName] + ' '  + U.[LastName]) AS ANMName  
		   ,CASE WHEN HT.[HPLCResultUpdatedOn] IS NULL THEN ' '  
		   ELSE (CONVERT(VARCHAR,HT.[HPLCResultUpdatedOn],103) + ' ' + CONVERT(VARCHAR(5),HT.[HPLCResultUpdatedOn],108)) END AS DiagnosisDateTime 
		   ,CONVERT(VARCHAR,SP.[DateofRegister],103) AS DateOfRegister
		   ,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) AS SampleCollectionDate
		   ,'TSCOD PROGRAM' AS ReferringDepartment
		   ,'Dr. Alok Srivastava' AS OrderingPhysician
		   ,(LTUM.[FirstName] + ' ' + LTUM.[LastName]) AS LabTechnicianName
		   --,'Mr. Solomon Ekka' AS LabTechnicianName
		   --,(PUM.[FirstName] + ' ' + PUM.[LastName]) AS PathologistName
		   ,'Dr. Sreeya Das' AS PathologistName
		FROM [dbo].[Tbl_HPLCTestResult] HT   
		LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON HD.BarcodeNo = HT.BarcodeNo   
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = HT.BarcodeNo   
		LEFT JOIN [dbo].[Tbl_CBCTestResult] CBC WITH (NOLOCK) ON CBC.BarcodeNo = HT.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SSTestResult] SST WITH (NOLOCK) ON SST.BarcodeNo = HT.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SPA   WITH (NOLOCK) ON SPA.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID   
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID  
		LEFT JOIN [dbo].[Tbl_CHCMaster] CHC WITH (NOLOCK)ON  CHC.ID = SP.CHCID  
		LEFT JOIN [dbo].[Tbl_PHCMaster] PHC WITH (NOLOCK)ON  PHC.ID = SP.PHCID  
		LEFT JOIN [dbo].[Tbl_BlockMaster] B WITH (NOLOCK)ON  CHC.BlockID = B.ID  
		LEFT JOIN [dbo].[Tbl_SCMaster] SCM WITH (NOLOCK)ON  SCM.ID = SP.SCID  
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON  RI.ID = SP.RIID  
		LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD WITH (NOLOCK) ON  HTD.Barcode = HT.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_UserMaster] U WITH (NOLOCK) ON U.ID = SP.AssignANM_ID 
		LEFT JOIN [dbo].[Tbl_UserMaster] LTUM WITH (NOLOCK) ON LTUM.ID = HT.CreatedBy
		LEFT JOIN [dbo].[Tbl_UserMaster] PUM WITH (NOLOCK) ON PUM.ID = HD.CreatedBy
		WHERE  HT.[CentralLabId] = @CentralLabId   
		AND HT.[BarcodeNo]  IN (SELECT BarcodeNo FROM Tbl_HPLCDiagnosisResult)  
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID)   
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID)   
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID)   
		AND HD.[IsDiagnosisComplete] = 1  
		AND (CONVERT(DATE,HT.[HPLCTestCompletedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		AND HTD.[ProcessStatus] = 1  AND HTD.[SampleStatus] = 1
	END  
	IF @StatusName =  'Abnormal Cases'   
	BEGIN  
		SELECT SP.[ID] AS SubjectId  
		   ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName  
		   ,(SP.[Spouse_FirstName] + ' ' + SP.[Spouse_MiddleName] + ' ' + SP.[Spouse_LastName]) AS SpouseName  
		   ,HT.[UniqueSubjectID]  
		   ,ST.[SubjectType]   
		   ,ISNULL(SPR.[RCHID] ,'') AS RCHID  
		   ,SP.[Age]   
		   ,SP.[Gender]  
		   ,(SPA.[Address2] + ' ' +SPA.[Address3]) AS SubjectAddress  
		   ,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB  
		   ,SP.[MobileNo] AS ContactNo  
		   ,SP.[Spouse_ContactNo] AS SpouseContactNo  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
			CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
		   (SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
			('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+  
			CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore  
		   ,ISNULL(SPR.[ECNumber],'') AS ECNumber  
		   ,HT.[BarcodeNo]  
		   ,DM.[Districtname]  
		   ,CHC.[CHCname]   
		   ,SCM.[SCname]  
		   ,B.[Blockname]  
		   ,PHC.[PHCname]  
		   ,RI.[RIsite] AS RIPoint  
		   ,CASE WHEN HD.[IsNormal] = 1 THEN 'Normal' ELSE 'Abnormal' END  AS SampleStatus  
		   ,CBC.[CBCResult]  
		   ,CBC.[MCV]  
		   ,CBC.[RDW]  
		   ,CBC.[RBC]  
		   ,CASE WHEN SST.[IsPositive] =  1 THEN 'Positive' ELSE 'Negative' END SSTResult  
		   ,HT.[HPLCResult]  
		   ,HT.[HbF]  
		   ,HT.[HbA0]  
		   ,HT.[HbA2]  
		   ,HT.[HbS]  
		   ,HT.[HbD]  
		   ,HT.[LabDiagnosis] AS LabDiagnosis  
		   ,HTD.[PdfFileName]  
		   ,HD.[SeniorPathologistRemarks]  
		   ,HD.[DiagnosisSummary]  
		   ,(U.[FirstName] + ' '  + U.[LastName]) AS ANMName  
		   ,CASE WHEN HT.[HPLCResultUpdatedOn] IS NULL THEN ' '  
		   ELSE (CONVERT(VARCHAR,HT.[HPLCResultUpdatedOn],103) + ' ' + CONVERT(VARCHAR(5),HT.[HPLCResultUpdatedOn],108)) END AS DiagnosisDateTime
		   ,CONVERT(VARCHAR,SP.[DateofRegister],103) AS DateOfRegister
		   ,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) AS SampleCollectionDate
		   ,'TSCOD PROGRAM' AS ReferringDepartment
		     ,'Dr. Alok Srivastava' AS OrderingPhysician
		   ,(LTUM.[FirstName] + ' ' + LTUM.[LastName]) AS LabTechnicianName
		   --,'Mr. Solomon Ekka' AS LabTechnicianName
		   --,(PUM.[FirstName] + ' ' + PUM.[LastName]) AS PathologistName
		   ,'Dr. Sreeya Das' AS PathologistName
		FROM [dbo].[Tbl_HPLCTestResult] HT   
		LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON HD.BarcodeNo = HT.BarcodeNo   
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = HT.BarcodeNo   
		LEFT JOIN [dbo].[Tbl_CBCTestResult] CBC WITH (NOLOCK) ON CBC.BarcodeNo = HT.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SSTestResult] SST WITH (NOLOCK) ON SST.BarcodeNo = HT.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SPA   WITH (NOLOCK) ON SPA.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID   
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID  
		LEFT JOIN [dbo].[Tbl_CHCMaster] CHC WITH (NOLOCK)ON  CHC.ID = SP.CHCID  
		LEFT JOIN [dbo].[Tbl_PHCMaster] PHC WITH (NOLOCK)ON  PHC.ID = SP.PHCID  
		LEFT JOIN [dbo].[Tbl_SCMaster] SCM WITH (NOLOCK)ON  SCM.ID = SP.SCID  
		LEFT JOIN [dbo].[Tbl_BlockMaster] B WITH (NOLOCK)ON  CHC.BlockID = B.ID  
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON  RI.ID = SP.RIID  
		LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD WITH (NOLOCK) ON  HTD.Barcode = HT.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_UserMaster] U WITH (NOLOCK) ON U.ID = SP.AssignANM_ID  
		LEFT JOIN [dbo].[Tbl_UserMaster] LTUM WITH (NOLOCK) ON LTUM.ID = HT.CreatedBy
		LEFT JOIN [dbo].[Tbl_UserMaster] PUM WITH (NOLOCK) ON PUM.ID = HD.CreatedBy
		WHERE  HT.[CentralLabId] = @CentralLabId   
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID)   
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID)   
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID)   
		AND HD.[IsDiagnosisComplete] = 1 AND HD.[IsNormal] = 0  
		AND (CONVERT(DATE,HT.[HPLCTestCompletedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103))   
		AND HTD.[ProcessStatus] = 1  AND HTD.[SampleStatus] = 1
	END  
	IF @StatusName =  'Normal Cases'   
	BEGIN  
		SELECT SP.[ID] AS SubjectId  
		   ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName  
		   ,(SP.[Spouse_FirstName] + ' ' + SP.[Spouse_MiddleName] + ' ' + SP.[Spouse_LastName]) AS SpouseName  
		   ,HT.[UniqueSubjectID]  
		   ,ST.[SubjectType]   
		   ,ISNULL(SPR.[RCHID] ,'') AS RCHID  
		   ,SP.[Age]   
		   ,SP.[Gender]  
		   ,(SPA.[Address2] + ' ' +SPA.[Address3]) AS SubjectAddress  
		   ,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB  
		   ,SP.[MobileNo] AS ContactNo  
		   ,SP.[Spouse_ContactNo] AS SpouseContactNo  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
			CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
		   (SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
			('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+  
			CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore  
		   ,ISNULL(SPR.[ECNumber],'') AS ECNumber  
		   ,HT.[BarcodeNo]  
		   ,DM.[Districtname]  
		   ,CHC.[CHCname]   
		   ,B.[Blockname]  
		   ,SCM.[SCname]  
		   ,PHC.[PHCname]  
		   ,RI.[RIsite] AS RIPoint  
		   ,CASE WHEN HD.[IsNormal] = 1 THEN 'Normal' ELSE 'Abnormal' END  AS SampleStatus  
		   ,CBC.[CBCResult]  
		   ,CBC.[MCV]  
		   ,CBC.[RDW]  
		   ,CBC.[RBC]  
		   ,CASE WHEN SST.[IsPositive] =  1 THEN 'Positive' ELSE 'Negative' END SSTResult  
		   ,HT.[HPLCResult]  
		   ,HT.[HbF]  
		   ,HT.[HbA0]  
		   ,HT.[HbA2]  
		   ,HT.[HbS]  
		   ,HT.[HbD]  
		   ,HT.[LabDiagnosis] AS LabDiagnosis  
		   ,HTD.[PdfFileName]  
		   ,HD.[SeniorPathologistRemarks]  
		   ,HD.[DiagnosisSummary]  
		   ,(U.[FirstName] + ' '  + U.[LastName]) AS ANMName  
		   ,CASE WHEN HT.[HPLCResultUpdatedOn] IS NULL THEN ' '  
		   ELSE (CONVERT(VARCHAR,HT.[HPLCResultUpdatedOn],103) + ' ' + CONVERT(VARCHAR(5),HT.[HPLCResultUpdatedOn],108)) END AS DiagnosisDateTime
		   ,CONVERT(VARCHAR,SP.[DateofRegister],103) AS DateOfRegister
		   ,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) AS SampleCollectionDate
		   ,'TSCOD PROGRAM' AS ReferringDepartment
		    ,'Dr. Alok Srivastava' AS OrderingPhysician
		   ,(LTUM.[FirstName] + ' ' + LTUM.[LastName]) AS LabTechnicianName
		   --,'Mr. Solomon Ekka' AS LabTechnicianName
		   --,(PUM.[FirstName] + ' ' + PUM.[LastName]) AS PathologistName
		   ,'Dr. Sreeya Das' AS PathologistName
		FROM [dbo].[Tbl_HPLCTestResult] HT   
		LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON HD.BarcodeNo = HT.BarcodeNo   
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = HT.BarcodeNo   
		LEFT JOIN [dbo].[Tbl_CBCTestResult] CBC WITH (NOLOCK) ON CBC.BarcodeNo = HT.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SSTestResult] SST WITH (NOLOCK) ON SST.BarcodeNo = HT.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SPA   WITH (NOLOCK) ON SPA.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID   
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID  
		LEFT JOIN [dbo].[Tbl_CHCMaster] CHC WITH (NOLOCK)ON  CHC.ID = SP.CHCID  
		LEFT JOIN [dbo].[Tbl_PHCMaster] PHC WITH (NOLOCK)ON  PHC.ID = SP.PHCID  
		LEFT JOIN [dbo].[Tbl_BlockMaster] B WITH (NOLOCK)ON  CHC.BlockID = B.ID  
		LEFT JOIN [dbo].[Tbl_SCMaster] SCM WITH (NOLOCK)ON  SCM.ID = SP.SCID  
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON  RI.ID = SP.RIID  
		LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD WITH (NOLOCK) ON  HTD.Barcode = HT.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_UserMaster] U WITH (NOLOCK) ON U.ID = SP.AssignANM_ID
		LEFT JOIN [dbo].[Tbl_UserMaster] LTUM WITH (NOLOCK) ON LTUM.ID = HT.CreatedBy
		LEFT JOIN [dbo].[Tbl_UserMaster] PUM WITH (NOLOCK) ON PUM.ID = HD.CreatedBy
		WHERE  HT.[CentralLabId] = @CentralLabId   
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID)   
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID)   
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID)   
		AND HD.[IsDiagnosisComplete] = 1 AND HD.[IsNormal] = 1  
		AND (CONVERT(DATE,HT.[HPLCTestCompletedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		AND HTD.[ProcessStatus] = 1  AND HTD.[SampleStatus] = 1
	END  
	IF @StatusName =  'Sr. Patho Consultation'   
	BEGIN  
		SELECT SP.[ID] AS SubjectId  
		   ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName  
		   ,(SP.[Spouse_FirstName] + ' ' + SP.[Spouse_MiddleName] + ' ' + SP.[Spouse_LastName]) AS SpouseName  
		   ,HT.[UniqueSubjectID]  
		   ,ST.[SubjectType]   
		   ,ISNULL(SPR.[RCHID] ,'') AS RCHID  
		   ,SP.[Age]   
		   ,SP.[Gender]  
		   ,(SPA.[Address2] + ' ' +SPA.[Address3]) AS SubjectAddress  
		   ,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB  
		   ,SP.[MobileNo] AS ContactNo  
		   ,SP.[Spouse_ContactNo] AS SpouseContactNo  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
			CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
		   (SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge  
		   ,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN  
			('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+  
			CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore  
		   ,ISNULL(SPR.[ECNumber],'') AS ECNumber  
		   ,(U.[FirstName] + ' '  + U.[LastName]) AS ANMName  
		   ,HT.[BarcodeNo]  
		   ,DM.[Districtname]  
		   ,CHC.[CHCname]   
		   ,SCM.[SCname]  
		   ,PHC.[PHCname]  
		   ,B.[Blockname]  
		   ,RI.[RIsite] AS RIPoint  
		   ,CASE WHEN HD.[IsNormal] = 1 THEN 'Normal' ELSE 'Abnormal' END  AS SampleStatus  
		   ,CBC.[CBCResult]  
		   ,CBC.[MCV]  
		   ,CBC.[RDW]  
		   ,CBC.[RBC]  
		   ,CASE WHEN SST.[IsPositive] =  1 THEN 'Positive' ELSE 'Negative' END SSTResult  
		   ,HT.[HPLCResult]  
		   ,HT.[HbF]  
		   ,HT.[HbA0]  
		   ,HT.[HbA2]  
		   ,HT.[HbS]  
		   ,HT.[HbD]  
		   ,HT.[LabDiagnosis] AS LabDiagnosis  
		   ,HTD.[PdfFileName]  
		   ,HD.[SeniorPathologistRemarks]  
		   ,HD.[DiagnosisSummary]  
		   ,CASE WHEN HT.[HPLCResultUpdatedOn] IS NULL THEN ' '  
		   ELSE (CONVERT(VARCHAR,HT.[HPLCResultUpdatedOn],103) + ' ' + CONVERT(VARCHAR(5),HT.[HPLCResultUpdatedOn],108)) END AS DiagnosisDateTime 
		   ,CONVERT(VARCHAR,SP.[DateofRegister],103) AS DateOfRegister
		   ,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) AS SampleCollectionDate
		   ,'TSCOD PROGRAM' AS ReferringDepartment
		   ,'Dr. Alok Srivastava' AS OrderingPhysician
		   ,(LTUM.[FirstName] + ' ' + LTUM.[LastName]) AS LabTechnicianName
		   --,'Mr. Solomon Ekka' AS LabTechnicianName
		   --,(PUM.[FirstName] + ' ' + PUM.[LastName]) AS PathologistName
		   ,'Dr. Sreeya Das' AS PathologistName
		FROM [dbo].[Tbl_HPLCTestResult] HT   
		LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON HD.BarcodeNo = HT.BarcodeNo   
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = HT.BarcodeNo   
		LEFT JOIN [dbo].[Tbl_CBCTestResult] CBC WITH (NOLOCK) ON CBC.BarcodeNo = HT.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SSTestResult] SST WITH (NOLOCK) ON SST.BarcodeNo = HT.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SPA   WITH (NOLOCK) ON SPA.UniqueSubjectID = HT.UniqueSubjectID  
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.ChildSubjectTypeID   
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID  
		LEFT JOIN [dbo].[Tbl_CHCMaster] CHC WITH (NOLOCK)ON  CHC.ID = SP.CHCID  
		LEFT JOIN [dbo].[Tbl_PHCMaster] PHC WITH (NOLOCK)ON  PHC.ID = SP.PHCID  
		LEFT JOIN [dbo].[Tbl_BlockMaster] B WITH (NOLOCK)ON  CHC.BlockID = B.ID  
		LEFT JOIN [dbo].[Tbl_SCMaster] SCM WITH (NOLOCK)ON  SCM.ID = SP.SCID  
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON  RI.ID = SP.RIID  
		LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD WITH (NOLOCK) ON  HTD.Barcode = HT.BarcodeNo  
		LEFT JOIN [dbo].[Tbl_UserMaster] U WITH (NOLOCK) ON U.ID = SP.AssignANM_ID
		LEFT JOIN [dbo].[Tbl_UserMaster] LTUM WITH (NOLOCK) ON LTUM.ID = HT.CreatedBy
		LEFT JOIN [dbo].[Tbl_UserMaster] PUM WITH (NOLOCK) ON PUM.ID = HD.CreatedBy
		WHERE  HT.[CentralLabId] = @CentralLabId   
		AND (@CHCID  = 0 OR SP.[CHCID] = @CHCID)   
		AND (@PHCID  = 0 OR SP.[PHCID] = @PHCID)   
		AND (@ANMID  = 0 OR SP.[AssignANM_ID] = @ANMID)   
		AND HD.[IsDiagnosisComplete] = 1 AND HD.[IsConsultSeniorPathologist] = 1  
		AND (CONVERT(DATE,HT.[HPLCTestCompletedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103))   
		AND HTD.[ProcessStatus] = 1  AND HTD.[SampleStatus] = 1
	END  
END