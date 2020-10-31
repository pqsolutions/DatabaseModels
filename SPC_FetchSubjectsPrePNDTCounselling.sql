USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectsPrePNDTCounselling' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectsPrePNDTCounselling
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectsPrePNDTCounselling] 
(
	  @UserId INT
	 ,@DistrictId INT
	 ,@CHCId INT
	 ,@PHCId INT
	 ,@ANMId INT  
)
AS
BEGIN
	SELECT SPD.[UniqueSubjectID] AS ANWSubjectId
		,SPD.[SpouseSubjectID]
		,(SPD.[FirstName] + ' ' + SPD.[LastName] )AS SubjectName
		,SPR.[RCHID]
		,(SPD.[Spouse_FirstName] + ' '+ SPD.[Spouse_LastName] ) AS SpouseName
		,SPD.[MobileNo] AS ContactNo
		,('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
		CONVERT(VARCHAR,SPR.[A])) AS ObstetricScore
		,CONVERT(DECIMAL(10,1),(SELECT [dbo].[FN_CalculateGestationalAge](SPD.[ID]))) AS [GestationalAge]
		,SPD.[AssignANM_ID] 
		,SPD.[Age]
		,SPDS.[Age] AS SpouseAge
		,SPR.[ECNumber] 
		,(CONVERT(VARCHAR,SPR.[LMP_Date],103))AS LMPDate
		,PPS.[ID] AS SchedulingId
		,PPS.[CounsellorId] 
		,(UM.[FirstName] +' '+UM.[LastName] ) AS CounsellorName
		,(CONVERT(VARCHAR,PPS.[CounsellingDateTime],103) + ' ' +
		  CONVERT(VARCHAR(5),CONVERT(TIME(2),CounsellingDateTime,103))) AS CounsellingDateTime

		,PRSD.[CBCResult] AS ANWCBCResult
		,CASE WHEN PRSD.[SSTStatus] = 'P' THEN 'Positive' ELSE 'Negative' END AS ANWSSTResult
		,PRSD.[HPLCTestResult] AS ANWHPLCResult

		,PRSDS.[CBCResult] AS SpouseCBCResult
		,CASE WHEN PRSDS.[SSTStatus] = 'P' THEN 'Positive' ELSE 'Negative' END AS SpouseSSTResult
		,PRSDS.[HPLCTestResult] AS SpouseHPLCResult

		,CTR.[MCV] AS ANW_MCV
		,CTR.[RDW] AS ANW_RDW
		,CTR.[RBC] AS ANW_RBC

		,HTR.[HbA0] AS ANW_HbA0
		,HTR.[HbA2] AS ANW_HbA2
		,HTR.[HbF] AS ANW_HbF
		,HTR.[HbS] AS ANW_HbS
		,HTR.[HbD] AS ANW_HbD

		,SCTR.[MCV] AS Spouse_MCV
		,SCTR.[RDW] AS Spouse_RDW
		,SCTR.[RBC] AS Spouse_RBC

		,SHTR.[HbF] AS Spouse_HbF
		,SHTR.[HbS] AS Spouse_HbS
		,SHTR.[HbD] AS Spouse_HbD
		,SHTR.[HbA0] AS Spouse_HbA0
		,SHTR.[HbA2] AS Spouse_HbA2
	
	FROM Tbl_PositiveResultSubjectsDetail PRSD
	LEFT JOIN Tbl_SubjectPrimaryDetail SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = PRSD.[UniqueSubjectID] 
	LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPR.[UniqueSubjectID]
	LEFT JOIN Tbl_SubjectPrimaryDetail SPDS WITH (NOLOCK) ON SPDS.[UniqueSubjectID] = SPD.[SpouseSubjectID]
	LEFT JOIN Tbl_PositiveResultSubjectsDetail PRSDS WITH (NOLOCK) ON PRSDS.[UniqueSubjectID] = SPDS.[UniqueSubjectID]
	LEFT JOIN Tbl_PrePNDTScheduling PPS WITH (NOLOCK) ON SPD.[UniqueSubjectID] = PPS.[ANWSubjectId] AND SPDS.[UniqueSubjectID] = PPS.[SpouseSubjectId]
	LEFT JOIN Tbl_UserMaster UM WITH(NOLOCK) ON PPS.[CounsellorId] = UM.[ID]
	LEFT JOIN Tbl_CBCTestResult CTR WITH (NOLOCK) ON CTR.[BarcodeNo] = PRSD.[BarcodeNo]
	LEFT JOIN Tbl_CBCTestResult SCTR WITH (NOLOCK) ON SCTR.[BarcodeNo] = PRSDS.[BarcodeNo]
	LEFT JOIN Tbl_HPLCTestResult HTR WITH (NOLOCK) ON HTR.[BarcodeNo] = PRSD.[BarcodeNo]
	LEFT JOIN Tbl_HPLCTestResult SHTR WITH (NOLOCK) ON SHTR.[BarcodeNo] = PRSDS.[BarcodeNo]
	WHERE PRSD.[HPLCStatus] = 'P' AND PRSD.[IsActive] = 1 AND PRSDS.[HPLCStatus] = 'P' AND PRSDS.[IsActive] = 1 
	AND  (SPD.[SubjectTypeID] = 1 OR SPD.ChildSubjectTypeID =1)
	AND PPS.[IsCounselled] = 0 
	AND PPS.[ANWSubjectId] NOT IN(SELECT ANWSubjectId FROM Tbl_PrePNDTCounselling)
	AND (SPD.[DistrictID] = @DistrictId OR SPD.[DistrictID] IN (SELECT DistrictID FROM Tbl_UserDistrictMaster WHERE UserId = @UserId))
	AND (@CHCId = 0 OR SPD.[CHCID] = @CHCId)
	AND (@PHCId = 0 OR SPD.[PHCID] = @PHCId)
	AND (@ANMId = 0 OR SPD.[AssignANM_ID] = @ANMId)
	ORDER BY [GestationalAge] DESC 
END

