USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details not collected the Sample by particular ANM user/ CHC

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectNotSampleCollected' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectNotSampleCollected
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectNotSampleCollected] 
(
	@UserID INT
	,@FromDate VARCHAR(50)
	,@ToDate VARCHAR(50)
	,@SubjectType INT
	,@RegisteredFrom INT
)
AS
BEGIN
	DECLARE @RegisterFrom VARCHAR(10), @CHCID INT, @StartDate VARCHAR(50), @EndDate VARCHAR(50)
	IF @FromDate = NULL OR @FromDate = ''
	BEGIN
		SET @StartDate = (SELECT CONVERT(VARCHAR,DATEADD(DAY ,-5,GETDATE()),103))
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
	SET @RegisterFrom = (SELECT CommonName FROM Tbl_ConstantValues WHERE   ID = @RegisteredFrom)
	SET @CHCID = (SELECT CHCID FROM Tbl_UserMaster WHERE ID = @UserID)
	
	IF @RegisterFrom = 'ANM'
	BEGIN
		SELECT SP.[ID]
			,SP.[UniqueSubjectID]
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
			,SPR.[RCHID]
			,SP.[SubjectTypeID]
			,ST.[SubjectType]  
			,(SP.[Spouse_FirstName] + ' ' + SP.[Spouse_MiddleName] + ' ' + SP.[Spouse_LastName]) AS SpouseName
			,(CONVERT(VARCHAR,SP.[DateofRegister],103)) AS  DateofRegister
			,SP.[MobileNo] AS ContactNo
			,(SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) AS GestationalAge
			,(SELECT [dbo].[FN_FindSampleType](SP.[ID])) AS SampleType
			,@StartDate AS FromDate
			,@EndDate AS ToDate
		FROM Tbl_SubjectPrimaryDetail SP
		LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.UniqueSubjectID  = SP.UniqueSubjectID 
		LEFT JOIN Tbl_SubjectTypeMaster ST WITH (NOLOCK) ON ST.ID = SP.SubjectTypeID 
		WHERE SP.[AssignANM_ID] = @UserID  
			AND (CONVERT(DATE,SP.[DateofRegister],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103))
			AND (@SubjectType = 0 OR SP.[SubjectTypeID] = @SubjectType)
			AND SP.[RegisteredFrom] = @RegisteredFrom
			AND SP.[ID]  IN (SELECT TOP 1 SubjectID  FROM Tbl_SubjectAddressDetail WHERE SubjectID = SP.ID)
			AND SP.[ID]  IN (SELECT TOP 1 SubjectID FROM Tbl_SubjectPregnancyDetail  WHERE SubjectID = SP.ID) 
			AND SP.[ID]  IN (SELECT TOP 1 SubjectID FROM Tbl_SubjectParentDetail   WHERE SubjectID  = SP.ID)
			AND SP.[ID] NOT IN (SELECT SubjectID FROM Tbl_SampleCollection WHERE SampleDamaged != 1 AND SampleTimeoutExpiry != 1)
			
	END
	ELSE IF @RegisterFrom = 'CHC'
    BEGIN
		SELECT SP.[ID]
			,SP.[UniqueSubjectID]
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
			,SPR.[RCHID]
			,SP.[SubjectTypeID]
			,ST.[SubjectType] 
			,(SP.[Spouse_FirstName] + ' ' + SP.[Spouse_MiddleName] + ' ' + SP.[Spouse_LastName]) AS SpouseName 
			,(CONVERT(VARCHAR,SP.[DateofRegister],105)) AS  DateofRegister
			,SP.[MobileNo] AS ContactNo
			,(SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) AS GestationalAge
			,(SELECT [dbo].[FN_FindSampleType](SP.[ID])) AS SampleType
			,@StartDate AS FromDate
			,@EndDate AS ToDate
		FROM Tbl_SubjectPrimaryDetail SP
		LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.UniqueSubjectID  = SP.UniqueSubjectID 
		LEFT JOIN Tbl_SubjectTypeMaster ST WITH (NOLOCK) ON ST.ID = SP.SubjectTypeID 
		WHERE SP.CHCID = @CHCID 
			AND (CONVERT(DATE,SP.[DateofRegister],103) BETWEEN CONVERT(DATE,@StartDate ,103) AND CONVERT(DATE,@EndDate,103))
			AND (@SubjectType = 0 OR SP.[ChildSubjectTypeID] = @SubjectType)
			AND SP.[RegisteredFrom] = @RegisteredFrom
			AND SP.[ID]  IN (SELECT TOP 1 SubjectID  FROM Tbl_SubjectAddressDetail WHERE SubjectID = SP.ID)
			AND SP.[ID]  IN (SELECT TOP 1 SubjectID FROM Tbl_SubjectPregnancyDetail  WHERE SubjectID = SP.ID) 
			AND SP.[ID]  IN (SELECT TOP 1 SubjectID FROM Tbl_SubjectParentDetail   WHERE SubjectID  = SP.ID)
			AND SP.[ID] NOT IN (SELECT SubjectID FROM Tbl_SampleCollection WHERE SampleDamaged != 1 AND SampleTimeoutExpiry != 1)
	END
END
      
