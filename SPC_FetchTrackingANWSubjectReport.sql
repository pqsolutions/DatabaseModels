--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchTrackingANWSubjectReport' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchTrackingANWSubjectReport 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchTrackingANWSubjectReport]
(	
	@UniqueSubjectId VARCHAR(250)
)
AS
BEGIN

	SELECT	TOP 1
			 CASE WHEN ISNULL(SPRD.[DateofRegister],'') = '' THEN '' 
			 ELSE CONVERT(VARCHAR,SPRD.[DateofRegister],103)
			 END  AS  [DateofRegister]
			 ,(SPRD.[FirstName] + '' + SPRD.[LastName]) AS SubjectName
			,SPAD.[UniqueSubjectID]
			,SPRD.[SpouseSubjectID]
			,SPRD.[Age]
			,SPRD.[Gender]
			,SPRD.[ChildSubjectTypeID] 
			,CASE WHEN  SPRD.[ChildSubjectTypeID] = 1 THEN CONVERT(VARCHAR,SPD.[LMP_Date],103) ELSE '' END AS LMPDate
			,CASE WHEN  SPRD.[ChildSubjectTypeID] = 1 THEN (SELECT [dbo].[FN_CalculateGestationalAge](SPRD.[ID])) ELSE '' END AS [Gestational_period]
			,(SPRD.[Spouse_FirstName] + '' + SPRD.[Spouse_LastName]) AS SpouseName
			,CASE WHEN SC.[BarcodeNo] IS NULL THEN 0 ELSE 1 END  AS SamplingStatus
			,CASE WHEN SC.[BarcodeNo] IS NULL THEN '' ELSE  SC.[BarcodeNo] END AS BarcodeNo
			,CASE WHEN SC.[SampleCollectionDate] IS NULL THEN '' ELSE
			(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' +CONVERT(VARCHAR(5),SC.[SampleCollectionTime],108)) END AS SampleCollectionDateTime

			,CASE WHEN ACS.[GenratedShipmentID] IS NULL THEN 0 ELSE 1 END ShipmentToCHC
			,CASE WHEN ACS.[GenratedShipmentID] IS NULL THEN '' ELSE ACS.[GenratedShipmentID] END AS ShipmentID
			,CASE WHEN ACS.[DateofShipment] IS NULL THEN '' ELSE
			(CONVERT(VARCHAR,ACS.[DateofShipment],103) + ' ' +CONVERT(VARCHAR(5),ACS.[TimeofShipment],108)) END AS ShipmentDateTime

			,CASE WHEN ACS.[ReceivedDate] IS NULL THEN 0 ELSE 1 END ReceivedAtTestingCHC
			,CASE WHEN ACS.[ReceivedDate] IS NULL THEN '' ELSE (CONVERT(VARCHAR,ACS.[ReceivedDate],103)) END AS ReceivedDateAtTestingCHC

			--,CASE WHEN CTD.[ID] IS NULL THEN 0 ELSE 1 END CHCSampleTestingStatus
			--,(CONVERT(VARCHAR,CTD.[TestedDateTime],103) + ' ' +CONVERT(VARCHAR(5),CTD.[TestedDateTime],108)) AS SampleTestedDateTime
			--,CASE WHEN CTD.[ConfirmationStatus] = 1 THEN 'YES' ELSE 'NO' END LTConfirmationStatus

			,CASE WHEN CR.[ID] IS NULL THEN 0 ELSE 1 END CBCTestProcessed
			,CASE WHEN CR.[ID] IS NULL THEN ''   WHEN CR.[IsPositive] = 1 THEN 'Positive' WHEN CR.[IsPositive]=0 THEN 'Negative' ELSE '' END AS CBCTestResult
			,CASE WHEN CR.[ID] IS NULL THEN '' ELSE 
			(CONVERT(VARCHAR,CR.[TestCompleteOn],103) + ' ' +CONVERT(VARCHAR(5),CR.[TestCompleteOn],108)) END AS CBCTestedDate

			,CASE WHEN SR.[ID] IS NULL THEN 0 ELSE 1 END SSTestProcessed
			,CASE WHEN SR.[ID] IS NULL THEN '' WHEN SR.[IsPositive] = 1 THEN 'Positive' WHEN SR.[IsPositive]=0 THEN 'Negative' ELSE '' END AS SSTResult
			,CASE WHEN SR.[ID] IS NULL THEN '' ELSE 
			(CONVERT(VARCHAR,SR.[UpdatedOn],103) + ' ' +CONVERT(VARCHAR(5),SR.[UpdatedOn],108)) END AS SSTTestedDate

			,CASE WHEN CCS.[GenratedShipmentID] IS NULL THEN 0 ELSE 1 END ShipmentToCentralLab
			,CASE WHEN CCS.[GenratedShipmentID] IS NULL THEN '' ELSE CCS.[GenratedShipmentID] END AS CHCShipmentID
			,CASE WHEN CCS.[DateofShipment] IS NULL THEN '' ELSE
			(CONVERT(VARCHAR,CCS.[DateofShipment],103) + ' ' +CONVERT(VARCHAR(5),CCS.[TimeofShipment],108)) END AS CHCShipmentDateTime

			,CASE WHEN CCS.[ReceivedDate] IS NULL THEN 0 ELSE 1 END ReceivedAtCentralLab
			,CASE WHEN CCS.[ReceivedDate] IS NULL THEN '' ELSE (CONVERT(VARCHAR,CCS.[ReceivedDate],103)) END AS ReceivedDateAtCentralLab

			,CASE WHEN HR.[ID] IS NULL THEN 0 ELSE 1 END HPLCTestProcessed
		--	,CASE WHEN HR.[ID] IS NULL THEN ''   WHEN HR.[IsNormal] = 1 THEN 'Normal' WHEN HR.[IsNormal]=0 THEN 'Abnormal' ELSE '' END AS HPLCSystemDiagnosis
			,CASE WHEN HR.[ID] IS NULL THEN '' ELSE 
			(CONVERT(VARCHAR,HR.[HPLCTestCompletedOn],103) + ' ' +CONVERT(VARCHAR(5),HR.[HPLCTestCompletedOn],108)) END AS HPLCTestedDate

			,CASE WHEN HD.[ID] IS NULL THEN 0 ELSE 1 END HPLCPathoTestProcessed
			,CASE WHEN HD.[ID] IS NULL THEN ''   WHEN HD.[IsNormal] = 1 THEN 'Negative' WHEN HD.[IsNormal]=0 THEN 'Positive' ELSE '' END AS HPLCResult
			,CASE WHEN HD.[ID] IS NULL THEN '' WHEN HD.[IsDiagnosisComplete] = 0 THEN 'Disagnosis Not Completed'  ELSE 
			(CONVERT(VARCHAR,HD.[UpdatedOn],103) + ' ' +CONVERT(VARCHAR(5),HD.[UpdatedOn],108)) END AS HPLCDiagnosisCompletedDate


			,CASE WHEN PS.[ID] IS NULL THEN 0 WHEN PS.[IsCounselled] = 0 THEN 0 ELSE 1 END PrePNDTCounsellingStatus
			,CASE WHEN PS.[ID] IS NULL THEN '' ELSE
			(CONVERT(VARCHAR,PS.[CounsellingDateTime],103) + ' ' +CONVERT(VARCHAR(5),PS.[CounsellingDateTime],108)) END AS PrePNDTCounsellingDateTime
			

			,CASE WHEN PT.[ID] IS NULL THEN 0 ELSE 1 END PNDTestStatus
			,CASE WHEN PT.[ID] IS NULL THEN ''  WHEN PT.[IsCompletePNDT] = 0 THEN 'Pending' ELSE 'Completed' END AS PNDTStatus 
			,CASE WHEN PC.[ID] IS NULL THEN ''  WHEN PT.[ID] IS NULL THEN 
			(CONVERT(VARCHAR,PC.[SchedulePNDTDate],103) + ' ' +CONVERT(VARCHAR(5),PC.[SchedulePNDTTime],108)) ELSE
			(CONVERT(VARCHAR,PT.[PNDTDateTime],103) + ' ' +CONVERT(VARCHAR(5),PT.[PNDTDateTime],108)) END AS PNDTDateTime

			,CASE WHEN POS.[ID] IS NULL THEN 0 WHEN POS.[IsCounselled] = 0 THEN 0 ELSE 1 END PostPNDTCounsellingStatus
			,CASE WHEN POS.[ID] IS NULL THEN '' ELSE
			(CONVERT(VARCHAR,POS.[CounsellingDateTime],103) + ' ' +CONVERT(VARCHAR(5),POS.[CounsellingDateTime],108)) END AS PostPNDTCounsellingDateTime

			,CASE WHEN MT.[ID] IS NULL THEN 0 ELSE 1 END MTPStatus
			,CASE WHEN POC.[ID] IS NULL THEN ''  WHEN MT.[ID] IS NULL THEN 
			(CONVERT(VARCHAR,POC.[ScheduleMTPDate],103) + ' ' +CONVERT(VARCHAR(5),POC.[ScheduleMTPTime],108)) ELSE
			(CONVERT(VARCHAR,MT.[MTPDateTime],103) + ' ' +CONVERT(VARCHAR(5),MT.[MTPDateTime],108)) END AS MTPDateTime
			
	FROM [dbo].[Tbl_SubjectPrimaryDetail] AS SPRD
	LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectParentDetail] SPAD WITH (NOLOCK) ON SPAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[UniqueSubjectID] = SPAD.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail] ASD WITH (NOLOCK) ON ASD.[BarcodeNo] = SC.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_ANMCHCShipments] ACS WITH (NOLOCK) ON ACS.[ID] = ASD.[ShipmentID]
	LEFT JOIN [dbo].[Tbl_CBCTestedDetail] CTD WITH (NOLOCK) ON CTD.[Barcode] = SC.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_CBCTestResult] CR WITH (NOLOCK) ON CR.[BarcodeNo] = SC.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_SSTestResult] SR WITH (NOLOCK) ON SR.[BarcodeNo] = SC.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_CHCShipmentsDetail] CSD WITH (NOLOCK) ON CSD.[BarcodeNo] = SC.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_CHCShipments] CCS WITH (NOLOCK) ON CCS.[ID] = CSD.[ShipmentID]
	LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD WITH (NOLOCK) ON HTD.[Barcode] = SC.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_HPLCTestResult] HR WITH (NOLOCK) ON HR.[BarcodeNo] = SC.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON HD.[BarcodeNo] = SC.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_PrePNDTScheduling] PS WITH (NOLOCK) ON PS.[ANWSubjectId] = HD.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_PrePNDTCounselling] PC WITH (NOLOCK) ON PC.[ANWSubjectId] = PS.[ANWSubjectId]
	LEFT JOIN [dbo].[Tbl_PNDTest] PT WITH (NOLOCK) ON PT.[ANWSubjectId] = PC.[ANWSubjectId]
	LEFT JOIN [dbo].[Tbl_PostPNDTScheduling] POS WITH (NOLOCK) ON POS.[ANWSubjectId] =  PT.[ANWSubjectId]
	LEFT JOIN [dbo].[Tbl_PostPNDTCounselling] POC WITH (NOLOCK) ON POC.[ANWSubjectId] =  POS.[ANWSubjectId]
	LEFT JOIN [dbo].[Tbl_MTPTest] MT WITH (NOLOCK) ON MT.[ANWSubjectId] = POC.[ANWSubjectId]
	WHERE SPAD.[UniqueSubjectID] = @UniqueSubjectId
	ORDER BY SC.[ID] DESC
END