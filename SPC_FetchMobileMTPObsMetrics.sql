USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileMTPObsMetrics' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileMTPObsMetrics
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobileMTPObsMetrics]
(
	@UserId INT
)AS
BEGIN

	CREATE  TABLE #TempMTPTable(ID INT IDENTITY(1,1),DateOfRegister DATE, ANWSubjectId VARCHAR(500),IsMTPAgreeYes BIT,IsCompleteMTP BIT)

	INSERT INTO #TempMTPTable(DateOfRegister,ANWSubjectId,IsMTPAgreeYes,IsCompleteMTP)
	(SELECT SP.[DateofRegister],MT.[ANWSubjectId],PPC.[IsMTPTestdAgreedYes], CASE WHEN ISNULL(MT.[ID],0) = 0  THEN 0 ELSE 1 END AS [IsCompleteMTP]
	FROM Tbl_PostPNDTCounselling PPC 
	LEFT JOIN Tbl_MTPTest MT WITH (NOLOCK) ON  PPC.[ANWSubjectId] = MT.[ANWSubjectId]
	LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = PPC.[ANWSubjectId]
	WHERE SP.[AssignANM_ID] = @UserId  AND PPC.[IsMTPTestdAgreedYes] = 1)

	--SELECT * FROM ##TempMTPTable
	SELECT (SELECT COUNT(1) FROM #TempMTPTable WHERE DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE()) AS MTPReffered 
		,(SELECT COUNT(1) FROM #TempMTPTable WHERE DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE() AND IsCompleteMTP = 1) AS MTPCompleted
		,(SELECT COUNT(1) FROM #TempMTPTable WHERE DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE() AND IsCompleteMTP = 0) AS MTPPending

	DROP TABLE  #TempMTPTable
END