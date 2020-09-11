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
	
	SELECT PRSD.[UniqueSubjectID]
		,ISNULL(PRSD.[CBCResult],'')  AS CBCTestResult
		,CASE WHEN ISNULL(PRSD.[SSTStatus],'') = 'P' THEN 'Positive'
			WHEN ISNULL(PRSD.[SSTStatus],'') = 'N' THEN 'Negative'
			ELSE '' END AS SSTestResult
		,ISNULL(PRSD.[HPLCTestResult],'')  AS HPLCTestResult
		,CASE WHEN ISNULL(PRSD.[HPLCStatus],'') = 'P' THEN 1
			ELSE 0 END AS IsHPLCPositive	
	FROM Tbl_PositiveResultSubjectsDetail PRSD
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = PRSD.[UniqueSubjectID]
	WHERE (PRSD.[UpdatedToANM] IS NULL OR PRSD.[UpdatedToANM] = 0) AND SP.[AssignANM_ID] = @UserId
	AND PRSD.[IsActive] = 1
END