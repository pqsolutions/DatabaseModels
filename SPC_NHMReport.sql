--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_NHMReport' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_NHMReport
END
GO
CREATE PROCEDURE [dbo].[SPC_NHMReport]
(
	@FromDate VARCHAR(50)
	,@ToDate VARCHAR(50)
	,@DistrictId INT
	,@BlockId INT
	,@CHCID INT
	,@UserId INT
)AS
BEGIN
	DECLARE  @StartDate VARCHAR(50), @EndDate VARCHAR(50), @Indexvar INT, @TotalCount INT,@SpouseSubjectId VARCHAr(250),@UniqueSubjectId VARCHAr(250)
		
	IF @FromDate = NULL OR @FromDate = ''
	BEGIN
		SET @StartDate = (SELECT CONVERT(VARCHAR,DATEADD(MONTH ,-3,GETDATE()),103))
	END
	ELSE
	BEGIN
		SET @StartDate = @FromDate
	END
	IF @ToDate = NULL OR @ToDate = ''
	BEGIN
		SET @EndDate = (SELECT CONVERT(VARCHAR,GETDATE(),103))
	END
	ELSE
	BEGIN
		SET @EndDate = @ToDate
	END

	CREATE  TABLE #TempUniqueSubjectID(ID INT IDENTITY(1,1),[UniqueSubjectId] VARCHAR(250)) 

	INSERT INTO #TempUniqueSubjectID([UniqueSubjectId])
	SELECT [UniqueSubjectId] FROM Tbl_SubjectPrimaryDetail SP
	LEFT JOIN Tbl_CHCMaster CM  WITH (NOLOCK) ON CM.ID = SP.CHCID
	LEFT JOIN Tbl_BlockMaster BM WITH (NOLOCK) ON CM.BlockID = BM.ID
	WHERE SP.ChildSubjectTypeID = 1 AND SP.ID IN( SELECT SubjectID FROM Tbl_SubjectParentDetail)
	AND (SP.DistrictID = @DistrictId OR @DistrictId = 0)
	AND (BM.ID = @BlockId OR @BlockId = 0)
	AND (SP.CHCID = @CHCID OR @CHCID = 0)
	AND (SP.AssignANM_ID = @UserId OR @UserId = 0)
	AND SP.DateofRegister BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)


	CREATE  TABLE #TempReportDetail(ID INT IDENTITY(1,1),ANMID VARCHAr(100), ANMName VARCHAR(MAX), UniqueSubjectId VARCHAR(250),SubjectType VARCHAr(150)) 
	SELECT @TotalCount = COUNT(1) FROM #TempUniqueSubjectID
	SET @IndexVar = 0  
	WHILE @Indexvar < @TotalCount  
	BEGIN
		SELECT @IndexVar = @IndexVar + 1
		SELECT  @UniqueSubjectId = UniqueSubjectId FROM #TempUniqueSubjectID  WHERE ID = @Indexvar
		SELECT @SpouseSubjectId = SpouseSubjectId FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectId = @UniqueSubjectId

	END

	SELECT * FROM #TempUniqueSubjectID

	DROP Table #TempUniqueSubjectID

END