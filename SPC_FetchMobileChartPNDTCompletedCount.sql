USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileChartPNDTCompletedCount' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileChartPNDTCompletedCount 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobileChartPNDTCompletedCount]
(
	@UserId INT
)AS
BEGIN
	
	CREATE  TABLE #TempMonthYear(ID INT IDENTITY(1,1),[Month] INT,[MonthName] VARCHAR(20), [Year] INT)
	DECLARE 
		  @start DATE = CONVERT(CHAR(8),DATEADD(MONTH,-5,GETDATE()),112)
		, @end DATE = CONVERT(CHAR(8),GETDATE(),112)
		,@Indexvar INT
		,@TotalCount INT

	;WITH cte AS 
	(
		SELECT dt = DATEADD(DAY, -(DAY(@start)-1), @start)

		UNION ALL

		SELECT DATEADD(MONTH, 1, dt)
		FROM cte
		WHERE dt < DATEADD(DAY, -(DAY(@end) - 1), @end)
	)INSERT INTO #TempMonthYear([Month],[MonthName],[Year])
	SELECT MONTH(dt) AS [Month],CONVERT(CHAR(4), dt, 100) AS[ MonthName] ,YEAR(dt) AS [Year]
	FROM cte
	--SELECT * FROM  #TempMonthYear
	CREATE  TABLE #TempInsert(ID INT IDENTITY(1,1),[Month] INT,[MonthName] VARCHAR(20), [Year] INT,[TotalCount] INT)

	DECLARE @Month INT ,@Year INT, @MonthName VARCHAR(20)
	SELECT @TotalCount = COUNT(1) FROM #TempMonthYear
	SET @IndexVar = 0  
	WHILE @Indexvar < @TotalCount  
	BEGIN
		SELECT @IndexVar = @IndexVar + 1
		SELECT @Month = [Month], @Year = [Year] ,@MonthName = [MonthName] FROM #TempMonthYear WHERE ID = @Indexvar
		INSERT INTO #TempInsert ([Month],[MonthName],[Year],[TotalCount])
		SELECT  @Month,@MonthName,@Year,COUNT(PT.[ID]) AS [TotalCount]
		FROM Tbl_PNDTest PT 
		LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = PT.[ANWSubjectId]
		WHERE  MONTH(PT.[PNDTDateTime]) = @Month AND YEAR (PT.[PNDTDateTime]) = @Year
		AND SP.[AssignANM_ID] = @UserId
		AND PT.[IsCompletePNDT] = 1
		
		SET @Month = 0 
		SET @Year=0 
		SET @MonthName=''
	END

	SELECT * FROM #TempInsert
	DROP TABLE #TempMonthYear
	DROP TABLE #TempInsert
END
 