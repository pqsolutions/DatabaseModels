--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectsPostPNDTScheduling' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectsPostPNDTScheduling 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectsPostPNDTScheduling] 
(
	 @UserId INT
	 ,@DistrictId INT
	 ,@CHCId INT
	 ,@PHCId INT
	 ,@ANMId INT 
)
AS
BEGIN
	SELECT DISTINCT PT.[ANWSubjectId]
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
		,SPR.[ECNumber] 
		,(CONVERT(VARCHAR,SPR.[LMP_Date],103))AS LMPDate
		,(CONVERT(VARCHAR,PT.[PNDTDateTime],103) + ' ' + CONVERT(VARCHAR(5),PT.[PNDTDateTime],108))AS PNDTDateTime
		
	FROM Tbl_PNDTestNew PT 
	LEFT JOIN Tbl_PNDTFoetusDetail PF WITH (NOLOCK) ON PF.[PNDTestId] = PT.[ID]
	LEFT JOIN Tbl_SubjectPrimaryDetail SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = PT.[ANWSubjectId]
	LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPR.[UniqueSubjectID] 
	WHERE PT.[IsCompletePNDT] = 1  
	AND  (SPD.[SubjectTypeID] = 1 OR SPD.ChildSubjectTypeID =1)
	AND SPD.[UniqueSubjectID] NOT IN (SELECT ANWSubjectId FROM Tbl_PostPNDTScheduling)
	AND (SPD.[DistrictID] = @DistrictId OR SPD.[DistrictID] IN (SELECT DistrictID FROM Tbl_UserDistrictMaster WHERE UserId = @UserId))
	AND (@CHCId = 0 OR SPD.[CHCID] = @CHCId)
	AND (@PHCId = 0 OR SPD.[PHCID] = @PHCId)
	AND (@ANMId = 0 OR SPD.[AssignANM_ID] = @ANMId)
	AND PF.[PlanForPregnencyContinue] = 0
	ORDER BY [GestationalAge] DESC  
END

