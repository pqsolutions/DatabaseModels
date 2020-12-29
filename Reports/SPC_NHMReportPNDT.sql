--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_NHMReportPNDT' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_NHMReportPNDT  --'','',0,0,0,0,1
END
GO
CREATE PROCEDURE [dbo].[SPC_NHMReportPNDT]
(
	@FromDate VARCHAR(50)
	,@ToDate VARCHAR(50)
	,@DistrictId INT
	,@BlockId INT
	,@CHCID INT
	,@ANMID INT
	,@Status INT
)AS
BEGIN
	DECLARE  @StartDate VARCHAR(50), @EndDate VARCHAR(50), @Indexvar INT, @TotalCount INT,@SpouseSubjectId VARCHAR(250),@UniqueSubjectId VARCHAR(250)
		
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

	CREATE  TABLE #TempUniqueSubjectID(ID INT IDENTITY(1,1),[UniqueSubjectId] VARCHAR(250)) 


	IF @Status = 1 -- All  PNDT Details (Pending & Completed)
	BEGIN
		INSERT INTO #TempUniqueSubjectID([UniqueSubjectId])
		SELECT SP.[UniqueSubjectId] FROM  Tbl_HPLCDiagnosisResult HD
		LEFT JOIN Tbl_HPLCTestResult HT WITH (NOLOCK) ON HT.BarcodeNo = HD.BarcodeNo
		LEFT JOIN Tbl_SampleCollection SC WITH (NOLOCK) ON SC.BarcodeNo = HD.BarcodeNo
		LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.UniqueSubjectID = SC.UniqueSubjectID
		LEFT JOIN Tbl_CHCMaster CM  WITH (NOLOCK) ON CM.ID = SP.CHCID
		LEFT JOIN Tbl_BlockMaster BM WITH (NOLOCK) ON CM.BlockID = BM.ID
		LEFT JOIN Tbl_UserMaster UM WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID
		WHERE SP.ChildSubjectTypeID = 1 AND SP.ID IN (SELECT SubjectID FROM Tbl_SubjectParentDetail)
		AND HD.[BarcodeNo] IN (SELECT BarcodeNo FROM Tbl_SampleCollection WHERE SampleDamaged != 1 AND SampleTimeoutExpiry != 1)
		AND (SP.DistrictID = @DistrictId OR @DistrictId = 0)
		AND (BM.ID = @BlockId OR @BlockId = 0)
		AND (SP.CHCID = @CHCID OR @CHCID = 0)
		AND (SP.AssignANM_ID = @ANMID OR @ANMID = 0)
		AND SP.DateofRegister BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103) 
		AND UM.UserType_ID IN (SELECT ID FROM Tbl_UserTypeMaster WHERE Usertype = 'ANM')
		AND HD.IsDiagnosisComplete = 1 AND HD.IsNormal = 0 AND LEN(SP.SpouseSubjectID) > 0 
		AND SP.SpouseSubjectID IN (SELECT UniqueSubjectID FROM Tbl_HPLCDiagnosisResult WHERE  IsDiagnosisComplete = 1 AND IsNormal = 0)
		AND SP.UniqueSubjectID  IN (SELECT ANWSubjectId FROM Tbl_PrePNDTScheduling WHERE IsCounselled = 1)
		AND SP.UniqueSubjectID  IN (SELECT ANWSubjectId FROM Tbl_PrePNDTCounselling WHERE IsPNDTAgreeYes = 1)

	END 
	IF @Status = 2 -- All  PNDT Pending Details
	BEGIN
		INSERT INTO #TempUniqueSubjectID([UniqueSubjectId])
		SELECT SP.[UniqueSubjectId] FROM  Tbl_HPLCDiagnosisResult HD
		LEFT JOIN Tbl_HPLCTestResult HT WITH (NOLOCK) ON HT.BarcodeNo = HD.BarcodeNo
		LEFT JOIN Tbl_SampleCollection SC WITH (NOLOCK) ON SC.BarcodeNo = HD.BarcodeNo
		LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.UniqueSubjectID = SC.UniqueSubjectID
		LEFT JOIN Tbl_CHCMaster CM  WITH (NOLOCK) ON CM.ID = SP.CHCID
		LEFT JOIN Tbl_BlockMaster BM WITH (NOLOCK) ON CM.BlockID = BM.ID
		LEFT JOIN Tbl_UserMaster UM WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID
		WHERE SP.ChildSubjectTypeID = 1 AND SP.ID IN (SELECT SubjectID FROM Tbl_SubjectParentDetail)
		AND HD.[BarcodeNo] IN (SELECT BarcodeNo FROM Tbl_SampleCollection WHERE SampleDamaged != 1 AND SampleTimeoutExpiry != 1)
		AND (SP.DistrictID = @DistrictId OR @DistrictId = 0)
		AND (BM.ID = @BlockId OR @BlockId = 0)
		AND (SP.CHCID = @CHCID OR @CHCID = 0)
		AND (SP.AssignANM_ID = @ANMID OR @ANMID = 0)
		AND SP.DateofRegister BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103) 
		AND UM.UserType_ID IN (SELECT ID FROM Tbl_UserTypeMaster WHERE Usertype = 'ANM')
		AND HD.IsDiagnosisComplete = 1 AND HD.IsNormal = 0 AND LEN(SP.SpouseSubjectID) > 0 
		AND SP.SpouseSubjectID IN (SELECT UniqueSubjectID FROM Tbl_HPLCDiagnosisResult WHERE  IsDiagnosisComplete = 1 AND IsNormal = 0)
		AND SP.UniqueSubjectID  IN (SELECT ANWSubjectId FROM Tbl_PrePNDTScheduling WHERE IsCounselled = 1)
		AND SP.UniqueSubjectID  IN (SELECT ANWSubjectId FROM Tbl_PrePNDTCounselling WHERE IsPNDTAgreeYes = 1)
		AND SP.UniqueSubjectID NOT IN (SELECT ANWSubjectId FROM Tbl_PNDTest)
	END 
	IF @Status = 3 -- All  PNDT Completed Details (include all results)
	BEGIN
		INSERT INTO #TempUniqueSubjectID([UniqueSubjectId])
		SELECT SP.[UniqueSubjectId] FROM  Tbl_HPLCDiagnosisResult HD
		LEFT JOIN Tbl_HPLCTestResult HT WITH (NOLOCK) ON HT.BarcodeNo = HD.BarcodeNo
		LEFT JOIN Tbl_SampleCollection SC WITH (NOLOCK) ON SC.BarcodeNo = HD.BarcodeNo
		LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.UniqueSubjectID = SC.UniqueSubjectID
		LEFT JOIN Tbl_CHCMaster CM  WITH (NOLOCK) ON CM.ID = SP.CHCID
		LEFT JOIN Tbl_BlockMaster BM WITH (NOLOCK) ON CM.BlockID = BM.ID
		LEFT JOIN Tbl_UserMaster UM WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID
		WHERE SP.ChildSubjectTypeID = 1 AND SP.ID IN (SELECT SubjectID FROM Tbl_SubjectParentDetail)
		AND HD.[BarcodeNo] IN (SELECT BarcodeNo FROM Tbl_SampleCollection WHERE SampleDamaged != 1 AND SampleTimeoutExpiry != 1)
		AND (SP.DistrictID = @DistrictId OR @DistrictId = 0)
		AND (BM.ID = @BlockId OR @BlockId = 0)
		AND (SP.CHCID = @CHCID OR @CHCID = 0)
		AND (SP.AssignANM_ID = @ANMID OR @ANMID = 0)
		AND SP.DateofRegister BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103) 
		AND UM.UserType_ID IN (SELECT ID FROM Tbl_UserTypeMaster WHERE Usertype = 'ANM')
		AND HD.IsDiagnosisComplete = 1 AND HD.IsNormal = 0 AND LEN(SP.SpouseSubjectID) > 0 
		AND SP.SpouseSubjectID IN (SELECT UniqueSubjectID FROM Tbl_HPLCDiagnosisResult WHERE  IsDiagnosisComplete = 1 AND IsNormal = 0)
		AND SP.UniqueSubjectID  IN (SELECT ANWSubjectId FROM Tbl_PrePNDTScheduling WHERE IsCounselled = 1)
		AND SP.UniqueSubjectID  IN (SELECT ANWSubjectId FROM Tbl_PrePNDTCounselling WHERE IsPNDTAgreeYes = 1)
		AND SP.UniqueSubjectID IN (SELECT ANWSubjectId FROM Tbl_PNDTest WHERE IsCompletePNDT=1)
	END 
	
	IF @Status = 4 --  PNDT Completed Details and result is Normal Foetus
	BEGIN
		INSERT INTO #TempUniqueSubjectID([UniqueSubjectId])
		SELECT SP.[UniqueSubjectId] FROM  Tbl_HPLCDiagnosisResult HD
		LEFT JOIN Tbl_HPLCTestResult HT WITH (NOLOCK) ON HT.BarcodeNo = HD.BarcodeNo
		LEFT JOIN Tbl_SampleCollection SC WITH (NOLOCK) ON SC.BarcodeNo = HD.BarcodeNo
		LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.UniqueSubjectID = SC.UniqueSubjectID
		LEFT JOIN Tbl_CHCMaster CM  WITH (NOLOCK) ON CM.ID = SP.CHCID
		LEFT JOIN Tbl_BlockMaster BM WITH (NOLOCK) ON CM.BlockID = BM.ID
		LEFT JOIN Tbl_UserMaster UM WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID
		WHERE SP.ChildSubjectTypeID = 1 AND SP.ID IN (SELECT SubjectID FROM Tbl_SubjectParentDetail)
		AND HD.[BarcodeNo] IN (SELECT BarcodeNo FROM Tbl_SampleCollection WHERE SampleDamaged != 1 AND SampleTimeoutExpiry != 1)
		AND (SP.DistrictID = @DistrictId OR @DistrictId = 0)
		AND (BM.ID = @BlockId OR @BlockId = 0)
		AND (SP.CHCID = @CHCID OR @CHCID = 0)
		AND (SP.AssignANM_ID = @ANMID OR @ANMID = 0)
		AND SP.DateofRegister BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103) 
		AND UM.UserType_ID IN (SELECT ID FROM Tbl_UserTypeMaster WHERE Usertype = 'ANM')
		AND HD.IsDiagnosisComplete = 1 AND HD.IsNormal = 0 AND LEN(SP.SpouseSubjectID) > 0 
		AND SP.SpouseSubjectID IN (SELECT UniqueSubjectID FROM Tbl_HPLCDiagnosisResult WHERE  IsDiagnosisComplete = 1 AND IsNormal = 0)
		AND SP.UniqueSubjectID  IN (SELECT ANWSubjectId FROM Tbl_PrePNDTScheduling WHERE IsCounselled = 1)
		AND SP.UniqueSubjectID  IN (SELECT ANWSubjectId FROM Tbl_PrePNDTCounselling WHERE IsPNDTAgreeYes = 1)
		AND SP.UniqueSubjectID IN (SELECT ANWSubjectId FROM Tbl_PNDTest WHERE PNDTResultId = 1 AND IsCompletePNDT=1)
	END 
	IF @Status = 5 --  PNDT Completed Details and result is Affected Foetus
	BEGIN
		INSERT INTO #TempUniqueSubjectID([UniqueSubjectId])
		SELECT SP.[UniqueSubjectId] FROM  Tbl_HPLCDiagnosisResult HD
		LEFT JOIN Tbl_HPLCTestResult HT WITH (NOLOCK) ON HT.BarcodeNo = HD.BarcodeNo
		LEFT JOIN Tbl_SampleCollection SC WITH (NOLOCK) ON SC.BarcodeNo = HD.BarcodeNo
		LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.UniqueSubjectID = SC.UniqueSubjectID
		LEFT JOIN Tbl_CHCMaster CM  WITH (NOLOCK) ON CM.ID = SP.CHCID
		LEFT JOIN Tbl_BlockMaster BM WITH (NOLOCK) ON CM.BlockID = BM.ID
		LEFT JOIN Tbl_UserMaster UM WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID
		WHERE SP.ChildSubjectTypeID = 1 AND SP.ID IN (SELECT SubjectID FROM Tbl_SubjectParentDetail)
		AND HD.[BarcodeNo] IN (SELECT BarcodeNo FROM Tbl_SampleCollection WHERE SampleDamaged != 1 AND SampleTimeoutExpiry != 1)
		AND (SP.DistrictID = @DistrictId OR @DistrictId = 0)
		AND (BM.ID = @BlockId OR @BlockId = 0)
		AND (SP.CHCID = @CHCID OR @CHCID = 0)
		AND (SP.AssignANM_ID = @ANMID OR @ANMID = 0)
		AND SP.DateofRegister BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103) 
		AND UM.UserType_ID IN (SELECT ID FROM Tbl_UserTypeMaster WHERE Usertype = 'ANM')
		AND HD.IsDiagnosisComplete = 1 AND HD.IsNormal = 0 AND LEN(SP.SpouseSubjectID) > 0 
		AND SP.SpouseSubjectID IN (SELECT UniqueSubjectID FROM Tbl_HPLCDiagnosisResult WHERE  IsDiagnosisComplete = 1 AND IsNormal = 0)
		AND SP.UniqueSubjectID  IN (SELECT ANWSubjectId FROM Tbl_PrePNDTScheduling WHERE IsCounselled = 1)
		AND SP.UniqueSubjectID  IN (SELECT ANWSubjectId FROM Tbl_PrePNDTCounselling WHERE IsPNDTAgreeYes = 1)
		AND SP.UniqueSubjectID IN (SELECT ANWSubjectId FROM Tbl_PNDTest WHERE PNDTResultId = 2 AND IsCompletePNDT=1)
	END 
	IF @Status = 6 --  PNDT Completed Details and result is Foetus is a carrier
	BEGIN
		INSERT INTO #TempUniqueSubjectID([UniqueSubjectId])
		SELECT SP.[UniqueSubjectId] FROM  Tbl_HPLCDiagnosisResult HD
		LEFT JOIN Tbl_HPLCTestResult HT WITH (NOLOCK) ON HT.BarcodeNo = HD.BarcodeNo
		LEFT JOIN Tbl_SampleCollection SC WITH (NOLOCK) ON SC.BarcodeNo = HD.BarcodeNo
		LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.UniqueSubjectID = SC.UniqueSubjectID
		LEFT JOIN Tbl_CHCMaster CM  WITH (NOLOCK) ON CM.ID = SP.CHCID
		LEFT JOIN Tbl_BlockMaster BM WITH (NOLOCK) ON CM.BlockID = BM.ID
		LEFT JOIN Tbl_UserMaster UM WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID
		WHERE SP.ChildSubjectTypeID = 1 AND SP.ID IN (SELECT SubjectID FROM Tbl_SubjectParentDetail)
		AND HD.[BarcodeNo] IN (SELECT BarcodeNo FROM Tbl_SampleCollection WHERE SampleDamaged != 1 AND SampleTimeoutExpiry != 1)
		AND (SP.DistrictID = @DistrictId OR @DistrictId = 0)
		AND (BM.ID = @BlockId OR @BlockId = 0)
		AND (SP.CHCID = @CHCID OR @CHCID = 0)
		AND (SP.AssignANM_ID = @ANMID OR @ANMID = 0)
		AND SP.DateofRegister BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103) 
		AND UM.UserType_ID IN (SELECT ID FROM Tbl_UserTypeMaster WHERE Usertype = 'ANM')
		AND HD.IsDiagnosisComplete = 1 AND HD.IsNormal = 0 AND LEN(SP.SpouseSubjectID) > 0 
		AND SP.SpouseSubjectID IN (SELECT UniqueSubjectID FROM Tbl_HPLCDiagnosisResult WHERE  IsDiagnosisComplete = 1 AND IsNormal = 0)
		AND SP.UniqueSubjectID  IN (SELECT ANWSubjectId FROM Tbl_PrePNDTScheduling WHERE IsCounselled = 1)
		AND SP.UniqueSubjectID  IN (SELECT ANWSubjectId FROM Tbl_PrePNDTCounselling WHERE IsPNDTAgreeYes = 1)
		AND SP.UniqueSubjectID IN (SELECT ANWSubjectId FROM Tbl_PNDTest WHERE PNDTResultId = 3 AND IsCompletePNDT=1)
	END 
	
	CREATE  TABLE #TempReportDetail(ID INT IDENTITY(1,1), ANMID VARCHAr(100), ANMName VARCHAR(MAX), UniqueSubjectId VARCHAR(250),  SubjectType VARCHAr(150), FirstName VARCHAR(250), SpouseSubjectId VARCHAR(250),
	RCHID VARCHAR(250),
	DateOfRegister VARCHAR(150), Barcode VARCHAR(150), RI VARCHAR(250), MobileNo VARCHAR(200), Village VARCHAR(MAX), GA VARCHAR(10), SampleCollected VARCHAR(20), SampleCollectionDateTime VARCHAR(250),
	SampleTestedDateTime VARCHAR(250), CBCResult VARCHAR(200), SSTResult VARCHAR(200), HPLCTestedDate VARCHAR(250), HPLCLabDiagnosis VARCHAR(MAX), HPLCPathoLabResult VARCHAR(MAX),
	PrePNDTCounselling VARCHAR(200), PNDTResult VARCHAR(MAX), PostPNDTCounselling VARCHAR(200), MTPService VARCHAR(MAX), 
	[ROW NUMBER] INT) 
	SELECT @TotalCount = COUNT(1) FROM #TempUniqueSubjectID
	SET @IndexVar = 0  
	WHILE @Indexvar < @TotalCount  
	BEGIN
		SELECT @IndexVar = @IndexVar + 1
		SELECT  @UniqueSubjectId = UniqueSubjectId FROM #TempUniqueSubjectID  WHERE ID = @Indexvar
		SELECT @SpouseSubjectId = SpouseSubjectId FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectId = @UniqueSubjectId
		
		INSERT INTO #TempReportDetail(ANMId, ANMName, UniqueSubjectId, SubjectType, FirstName, SpouseSubjectId, RCHID, DateOfRegister, Barcode, RI, MobileNo, Village, GA, SampleCollected, SampleCollectionDateTime,
		SampleTestedDateTime, CBCResult, SSTResult, HPLCTestedDate, HPLCLabDiagnosis, HPLCPathoLabResult, PrePNDTCounselling, PNDTResult, PostPNDTCounselling, MTPService,
		[ROW NUMBER])
		SELECT * FROM (
		SELECT um.[User_gov_code]
			  ,(UM.[FirstName] + ' '+ UM.[LastName]) AS ANMName
			  ,SP.[UniqueSubjectID]
			  ,ST.[SubjectType]
			  ,(SELECT [dbo].[FN_ProperCase] (SP.[FirstName])) AS FirstName
			  --,CASE WHEN LEN(SP.[SpouseSubjectID] ) > 0 THEN SP.[SpouseSubjectID] ELSE '--' END AS SpouseSubjectID
			  ,CASE WHEN LEN(SP.[SpouseSubjectID] ) > 0 THEN 'Yes' ELSE 'No' END AS SpouseSubjectID
			  ,SPD.[RCHID]
			  ,(CONVERT(VARCHAR,SP.[DateofRegister],103)) AS RegisteredDate
			  ,CASE WHEN SC.[BarcodeNo] IS NULL THEN '--' ELSE SC.[BarcodeNo] END AS BarcodeNo
			  ,RM.[RIsite]
			  ,SP.[MobileNo]
			  ,SAD.[Address3]
			  ,(SELECT [dbo].[FN_CalculateGestationalAge](SPD.[SubjectID])) AS [GA] 
			  ,CASE WHEN SC.[ID] IS NULL THEN 'No' WHEN SC.[SampleTimeoutExpiry] = 1 THEN 'Timeout Expiry' WHEN SC.[SampleDamaged] =1 THEN 'Sample Damaged' ELSE 'Yes' END AS SampleCollected
			  ,CASE WHEN SC.[ID] IS NULL THEN '--' ELSE (CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' +CONVERT(VARCHAR(5),SC.[SampleCollectionTime],108)) END AS SampleCollectionDateTime
			  ,CASE WHEN CR.[ID] IS NULL THEN '--' ELSE (CONVERT(VARCHAR,CR.[TestCompleteOn],103) + ' '+ CONVERT(VARCHAR(5),CR.[TestCompleteOn],108)) END AS SampleTestedDateTime
			  ,CASE WHEN CR.[ID] IS NULL THEN '--' ELSE CR.[CBCResult] END AS CBCResult
			  ,CASE WHEN SST.[ID] IS NULL THEN '--' WHEN SST.[IsPositive] = 1 THEN 'Positive' WHEN SST.[IsPositive]=0 THEN 'Negative' END AS SSTResult
			  ,CASE WHEN HT.[ID] IS NULL THEN '--' ELSE CONVERT(VARCHAR,HT.[HPLCTestCompletedOn],103) END AS HPLCTestedDate
			  ,CASE WHEN HT.[ID] IS NULL THEN '--' WHEN HT.[IsPositive] IS NULL THEN '--' ELSE HT.[LabDiagnosis] END AS HPLCLabDiagnosis
			  ,CASE WHEN  HT.[ID] IS NULL THEN '--' WHEN HT.[IsPositive] IS NULL THEN '--' ELSE HT.[HPLCResult] END AS HPLCPathoLabResult
			  ,CASE WHEN PS.[ID] IS NULL THEN '--' WHEN (PC.[ID] IS NOT NULL AND PS.[IsCounselled] = 0 ) THEN 'Pending' WHEN PC.[IsPNDTAgreeYes] = 1  THEN 'Agreed' WHEN PC.[IsPNDTAgreeNo] = 1  THEN 'Disagreed'              
			   WHEN PC.[IsPNDTAgreePending] = 1  THEN 'Decision Awaiting'  END PrePNDTCounselling
			  ,CASE WHEN PT.[ID] IS NULL THEN '--' WHEN PT.[PNDTResultId] = 1 THEN 'Normal Foetus' WHEN  PT.[PNDTResultId] = 2 THEN 'Affected Foetus'  
			  WHEN PT.[PNDTResultId] = 3 THEN 'Foetus is a carrier' END AS PNDTResult
			  ,CASE WHEN POS.[ID] IS NULL THEN '--' WHEN (POC.[ID] IS NOT NULL AND POS.[IsCounselled] = 0 ) THEN 'Pending' WHEN POC.[IsMTPTestdAgreedYes] = 1  THEN 'Agreed' WHEN POC.[IsMTPTestdAgreedNo] = 1  THEN 'Disagreed'              
			   WHEN POC.[IsMTPTestdAgreedPending] = 1  THEN 'Decision Awaiting'  END PostPNDTCounselling 
			  ,CASE WHEN MT.[ID] IS NULL THEN '--' ELSE 'Completed' END MTPService
			  ,ROW_NUMBER() OVER (PARTITION BY SP.[UniqueSubjectID]  ORDER BY SC.[CreatedOn] DESC) AS [ROW NUMBER]
		FROM Tbl_SubjectPrimaryDetail SP
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SP.[UniqueSubjectID] 
		LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SP.[UniqueSubjectID] 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[UniqueSubjectID] = SP.[UniqueSubjectID]
		LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = SP.[AssignANM_ID]
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[ChildSubjectTypeID]
		LEFT JOIN [dbo].[Tbl_RIMaster] RM WITH (NOLOCK) ON RM.[ID] = SP.[RIID]
		LEFT JOIN [dbo].[Tbl_CBCTestResult] CR WITH (NOLOCK) ON CR.[BarcodeNo] = SC.[BarcodeNo]
		LEFT JOIN [dbo].[Tbl_SSTestResult] SST WITH (NOLOCK) ON SST.[BarcodeNo] = SC.[BarcodeNo]
		LEFT JOIN [dbo].[Tbl_HPLCTestResult] HT WITH (NOLOCK) ON HT.[BarcodeNo] = SC.[BarcodeNo]
		LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON HD.[BarcodeNo] = SC.[BarcodeNo] AND HD.[IsDiagnosisComplete] = 1
		LEFT JOIN [dbo].[Tbl_PrePNDTScheduling] PS WITH (NOLOCK) ON PS.[ANWSubjectId] = HD.[UniqueSubjectID]            
		LEFT JOIN [dbo].[Tbl_PrePNDTCounselling] PC WITH (NOLOCK) ON PC.[ANWSubjectId] = PS.[ANWSubjectId]            
		LEFT JOIN [dbo].[Tbl_PNDTest] PT WITH (NOLOCK) ON PT.[ANWSubjectId] = PC.[ANWSubjectId]            
		LEFT JOIN [dbo].[Tbl_PostPNDTScheduling] POS WITH (NOLOCK) ON POS.[ANWSubjectId] =  PT.[ANWSubjectId]            
		LEFT JOIN [dbo].[Tbl_PostPNDTCounselling] POC WITH (NOLOCK) ON POC.[ANWSubjectId] =  POS.[ANWSubjectId]            
		LEFT JOIN [dbo].[Tbl_MTPTest] MT WITH (NOLOCK) ON MT.[ANWSubjectId] = POC.[ANWSubjectId] 
		WHERE SP.[UniqueSubjectID] = @UniqueSubjectId 
		)GROUPS
		WHERE GROUPS.[ROW NUMBER] = 1 
		ORDER BY GROUPS.UniqueSubjectID ASC

		IF LEN(@SpouseSubjectId) > 0 
		BEGIN
			INSERT INTO #TempReportDetail(ANMId, ANMName, UniqueSubjectId, SubjectType, FirstName, SpouseSubjectId, RCHID, DateOfRegister, Barcode, RI, MobileNo, Village, GA, SampleCollected, SampleCollectionDateTime,
			SampleTestedDateTime, CBCResult, SSTResult, HPLCTestedDate, HPLCLabDiagnosis, HPLCPathoLabResult, PrePNDTCounselling, PNDTResult, PostPNDTCounselling, MTPService,
			[ROW NUMBER])
			SELECT * FROM (
			SELECT um.[User_gov_code]
				  ,(UM.[FirstName] + ' '+ UM.[LastName]) AS ANMName
				  ,SP.[UniqueSubjectID]
				  ,ST.[SubjectType]
				  ,(SELECT [dbo].[FN_ProperCase] (SP.[FirstName])) AS FirstName
				   --,CASE WHEN LEN(SP.[SpouseSubjectID] ) > 0 THEN SP.[SpouseSubjectID] ELSE '--' END AS SpouseSubjectID
					,CASE WHEN LEN(SP.[SpouseSubjectID] ) > 0 THEN 'Yes' ELSE 'No' END AS SpouseSubjectID
				  ,SPD.[RCHID]
				  ,(CONVERT(VARCHAR,SP.[DateofRegister],103)) AS RegisteredDate
				  ,CASE WHEN SC.[BarcodeNo] IS NULL THEN '--' ELSE SC.[BarcodeNo] END AS BarcodeNo
				  ,RM.[RIsite]
				  ,SP.[MobileNo]
				  ,SAD.[Address3]
				  ,'--' AS [GA] 
				  ,CASE WHEN SC.[ID] IS NULL THEN 'No' ELSE 'Yes' END AS SampleCollected
				  ,CASE WHEN SC.[ID] IS NULL THEN '--' ELSE (CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' +CONVERT(VARCHAR(5),SC.[SampleCollectionTime],108)) END AS SampleCollectionDateTime
				  ,CASE WHEN CR.[ID] IS NULL THEN '--' ELSE (CONVERT(VARCHAR,CR.[TestCompleteOn],103) + ' '+ CONVERT(VARCHAR(5),CR.[TestCompleteOn],108)) END AS SampleTestedDateTime
				  ,CASE WHEN CR.[ID] IS NULL THEN '--' ELSE CR.[CBCResult] END AS CBCResult
				  ,CASE WHEN SST.[ID] IS NULL THEN '--' WHEN SST.[IsPositive] = 1 THEN 'Positive' WHEN SST.[IsPositive]=0 THEN 'Negative' END AS SSTResult
				  ,CASE WHEN HT.[ID] IS NULL THEN '--' ELSE CONVERT(VARCHAR,HT.[HPLCTestCompletedOn],103) END AS HPLCTestedDate
				  ,CASE WHEN HT.[ID] IS NULL THEN '--' WHEN HT.[IsPositive] IS NULL THEN '--' ELSE HT.[LabDiagnosis] END AS HPLCLabDiagnosis
				  ,CASE WHEN  HT.[ID] IS NULL THEN '--' WHEN HT.[IsPositive] IS NULL THEN '--' ELSE HT.[HPLCResult] END AS HPLCPathoLabResult
				  ,CASE WHEN PS.[ID] IS NULL THEN '--' WHEN (PC.[ID] IS NOT NULL AND PS.[IsCounselled] = 0 ) THEN 'Pending' WHEN PC.[IsPNDTAgreeYes] = 1  THEN 'Agreed' WHEN PC.[IsPNDTAgreeNo] = 1  THEN 'Disagreed'              
				   WHEN PC.[IsPNDTAgreePending] = 1  THEN 'Decision Awaiting'  END PrePNDTCounselling
				   ,'--' AS PNDTResult
				 -- ,CASE WHEN PT.[ID] IS NULL THEN '-' WHEN PT.[PNDTResultId] = 1 THEN 'Normal Foetus' WHEN  PT.[PNDTResultId] = 2 THEN 'Affected Foetus'  WHEN PT.[PNDTResultId] = 3 THEN 'Foetus is a carrier' END AS PNDTResult
				  ,CASE WHEN POS.[ID] IS NULL THEN '--' WHEN  (POC.[ID] IS NOT NULL AND POS.[IsCounselled] = 0 ) THEN 'Pending' WHEN POC.[IsMTPTestdAgreedYes] = 1  THEN 'Agreed' WHEN POC.[IsMTPTestdAgreedNo] = 1  THEN 'Disagreed'              
				   WHEN POC.[IsMTPTestdAgreedPending] = 1  THEN 'Decision Awaiting'  END PostPNDTCounselling 
				  ,'--' AS MTPService
				  --,CASE WHEN MT.[ID] IS NULL THEN '--' ELSE 'Completed' END MTPService
				  ,ROW_NUMBER() OVER (PARTITION BY SP.[UniqueSubjectID]  ORDER BY SC.[CreatedOn] DESC) AS [ROW NUMBER]
			FROM Tbl_SubjectPrimaryDetail SP
			LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SP.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SP.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[UniqueSubjectID] = SP.[UniqueSubjectID]
			LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = SP.[AssignANM_ID]
			LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[ChildSubjectTypeID]
			LEFT JOIN [dbo].[Tbl_RIMaster] RM WITH (NOLOCK) ON RM.[ID] = SP.[RIID]
			LEFT JOIN [dbo].[Tbl_CBCTestResult] CR WITH (NOLOCK) ON CR.[BarcodeNo] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_SSTestResult] SST WITH (NOLOCK) ON SST.[BarcodeNo] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_HPLCTestResult] HT WITH (NOLOCK) ON HT.[BarcodeNo] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON HD.[BarcodeNo] = SC.[BarcodeNo] AND HD.[IsDiagnosisComplete] = 1
			LEFT JOIN [dbo].[Tbl_PrePNDTScheduling] PS WITH (NOLOCK) ON PS.[SpouseSubjectId] = HD.[UniqueSubjectID]            
			LEFT JOIN [dbo].[Tbl_PrePNDTCounselling] PC WITH (NOLOCK) ON PC.[SpouseSubjectId] = PS.[SpouseSubjectId]            
			LEFT JOIN [dbo].[Tbl_PNDTest] PT WITH (NOLOCK) ON PT.[SpouseSubjectId] = PC.[SpouseSubjectId]            
			LEFT JOIN [dbo].[Tbl_PostPNDTScheduling] POS WITH (NOLOCK) ON POS.[SpouseSubjectId] =  PT.[SpouseSubjectId]            
			LEFT JOIN [dbo].[Tbl_PostPNDTCounselling] POC WITH (NOLOCK) ON POC.[SpouseSubjectId] =  POS.[SpouseSubjectId]            
			LEFT JOIN [dbo].[Tbl_MTPTest] MT WITH (NOLOCK) ON MT.[SpouseSubjectId] = POC.[SpouseSubjectId] 
			WHERE SP.[UniqueSubjectID] = @SpouseSubjectId 
			)GROUPS
			WHERE GROUPS.[ROW NUMBER] = 1 
			ORDER BY GROUPS.UniqueSubjectID ASC

		END

	END

	SELECT * FROM #TempReportDetail

	DROP Table #TempUniqueSubjectID
	DROP Table #TempReportDetail


END