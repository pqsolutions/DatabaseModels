USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileSubjectResultDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileSubjectResultDetail
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobileSubjectResultDetail]
(
	@UserId INT
)AS
BEGIN
	SELECT SP.[UniqueSubjectID]
		,(SELECT [dbo].[FN_FindResult](SP.[UniqueSubjectID],'CBC')) AS CBCTestResult
		,(SELECT [dbo].[FN_FindResult](SP.[UniqueSubjectID],'SST')) AS SSTestResult
		,(SELECT [dbo].[FN_FindResult](SP.[UniqueSubjectID],'HPLC')) AS HPLCTestResult
		,CASE WHEN (SELECT TOP 1 IsPositive FROM Tbl_HPLCTestResult WHERE UniqueSubjectID = SP.[UniqueSubjectID] ORDER BY ID DESC) = 1 
		THEN 1 ELSE 0 END AS IsHPLCPositive
	FROM [dbo].[Tbl_CBCTestResult] CT
	LEFT JOIN [dbo].[Tbl_SSTestResult] ST WITH (NOLOCK) ON ST.[UniqueSubjectID] = CT.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_HPLCTestResult] HT WITH (NOLOCK) ON HT.[UniqueSubjectID] = CT.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = ST.[UniqueSubjectID]
	OR SP.[UniqueSubjectID] = CT.[UniqueSubjectID] OR SP.[UniqueSubjectID] = HT.[UniqueSubjectID]
	WHERE SP.[AssignANM_ID] = @UserId  AND (CT.IsPositive = 1 OR ST.IsPositive = 1 OR HT.IsPositive = 1) 
	AND (CT.[UpdatedToANM] IS NULL OR ST.[UpdatedToANM] IS NULL OR HT.[UpdatedToANM] IS NULL)
END