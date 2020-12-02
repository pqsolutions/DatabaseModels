--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileHPLCTestMetrics' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileHPLCTestMetrics 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobileHPLCTestMetrics]
(
	@UserId INT
)AS
BEGIN

	CREATE  TABLE #TempMTPTable(ID INT IDENTITY(1,1),DateOfRegister DATE, UniqueSubjectId VARCHAR(500),SpouseSubjectId VARCHAR(500),SubType INT)

	INSERT INTO #TempMTPTable(DateOfRegister,UniqueSubjectId,SpouseSubjectId,SubType)
	(SELECT SP.[DateofRegister],HT.[UniqueSubjectID],SP.[SpouseSubjectID],SP.[ChildSubjectTypeID]
	FROM  Tbl_HPLCDiagnosisResult HT 
	LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = HT.[UniqueSubjectID]
	WHERE SP.[AssignANM_ID] = @UserId AND HT.[IsNormal] = 0) 

	--SELECT * FROM ##TempMTPTable
	SELECT (SELECT COUNT(1) FROM #TempMTPTable WHERE (DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE()) AND SubType = 1) AS ANWPositive 
		,(SELECT COUNT(1) FROM #TempMTPTable WHERE DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE() AND SubType = 2) AS SpouseEvaluationCompleted
		,( (SELECT COUNT(1) FROM #TempMTPTable WHERE (DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE()) AND SubType = 1) -
		(SELECT COUNT(1) FROM #TempMTPTable WHERE DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE() AND SubType = 2)) AS SpouseEvaluationPending

	DROP TABLE  #TempMTPTable
END