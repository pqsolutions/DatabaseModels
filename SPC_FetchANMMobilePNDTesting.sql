USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are PrePNDTesting for ANM Mobile

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMMobilePNDTesting' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMMobilePNDTesting 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMMobilePNDTesting] 
(
	@UserId INT
)
AS
BEGIN
	SELECT SP.[UniqueSubjectID] 
		,CONVERT(VARCHAR,PT.[PNDTDateTime],103) AS PNDTDate
		,CONVERT(VARCHAR(5),PT.[PNDTDateTime],108) AS PNDTTime
		,(UM.[FirstName] + ' ' + UM.[LastName]) AS CounsellorName
		,(UM1.[FirstName] + ' ' + UM1.[LastName]) AS ObstetricianName
		,PT.[ClinicalHistory] 
		,PT.[Examination] 
		,CASE WHEN POT.[ProcedureName] = 'Others' THEN POT.[ProcedureName] + '(' + PT.[OthersProcedureofTesting] + ')'
			ELSE POT.[ProcedureName] END AS PNDTProcedureOfTesting
		,PD.[DiagnosisName] AS PNDTDiagnosisName 
		,PRM.[ResultName] AS PNDTResults
		,(SELECT [dbo].[FN_GetPNDTSubjectComplications](PT.[ID])) AS PNDTSideEffects
	FROM  Tbl_PNDTest PT
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = PT.[ANWSubjectId]
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = PT.[CounsellorId] 
	LEFT JOIN [dbo].[Tbl_UserMaster] UM1 WITH (NOLOCK) ON UM1.[ID] = PT.[ObstetricianId]  
	LEFT JOIN [dbo].[Tbl_PNDTProcedureOfTestingMaster] POT WITH (NOLOCK) ON PT.[ProcedureofTestingId] = POT.[ID] 
	LEFT JOIN [dbo].[Tbl_PNDTResultMaster]  PRM WITH (NOLOCK) ON PRM.[ID] = PT.[PNDTResultId]
	LEFT JOIN [dbo].[Tbl_PNDTDiagnosisMaster] PD WITH (NOLOCK) ON PD.[ID] = PT.[PNDTDiagnosisId] 
	WHERE SP.[AssignANM_ID]  = @UserId    
	ORDER BY SP.[UniqueSubjectID] 
	
END