USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobilePostMTPMetrics' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobilePostMTPMetrics
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobilePostMTPMetrics]
(
	@UserId INT
)AS
BEGIN

	CREATE  TABLE #TempMTPTable(ID INT IDENTITY(1,1),DateOfRegister DATE, ANWSubjectId VARCHAR(500),MTPDateTime DATETIME,DateDifference INT)

	INSERT INTO #TempMTPTable(DateOfRegister,ANWSubjectId,MTPDateTime,DateDifference)
	(SELECT SP.[DateofRegister],MT.[ANWSubjectId],MT.[MTPDateTime],DATEDIFF(DAY,MT.[MTPDateTime],GETDATE())
	FROM  Tbl_MTPTest MT 
	LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = MT.[ANWSubjectId]
	WHERE SP.[AssignANM_ID] = @UserId)  

	--SELECT * FROM ##TempMTPTable
	SELECT (SELECT COUNT(1) FROM #TempMTPTable WHERE (DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE()) AND DateDifference <= 30) AS PostMTP0to30Days 
		,(SELECT COUNT(1) FROM #TempMTPTable WHERE DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE() AND   DateDifference > 30 AND  DateDifference <= 45) AS PostMTP31to45Days
		,(SELECT COUNT(1) FROM #TempMTPTable WHERE DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE() AND  DateDifference > 45 AND  DateDifference <= 60) AS PostMTP46to60Days

	DROP TABLE  #TempMTPTable
END