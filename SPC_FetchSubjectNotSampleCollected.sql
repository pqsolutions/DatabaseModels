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
	,@RegisteredFrom VARCHAR(10)
)
AS
BEGIN

	DECLARE @RegisterFrom INT,@CHCID INT
	SET @RegisterFrom = (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = @RegisteredFrom AND comments='RegisterFrom')
	SET @CHCID = (SELECT CHCID FROM Tbl_UserMaster WHERE ID = @UserID)
	
	IF @RegisteredFrom = 'ANM'
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
		FROM Tbl_SubjectPrimaryDetail SP
		LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.ID  = SP.ID 
		LEFT JOIN Tbl_SubjectTypeMaster ST WITH (NOLOCK) ON ST.ID = SP.SubjectTypeID 
		WHERE SP.[AssignANM_ID] = @UserID  
			AND (SP.[DateofRegister] BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103))
			AND (@SubjectType = 0 OR SP.[SubjectTypeID] = @SubjectType)
			AND SP.[RegisteredFrom] = @RegisterFrom
			AND SP.[ID] NOT IN (SELECT SubjectID FROM Tbl_SampleCollection WHERE SampleDamaged != 1 AND SampleTimeoutExpiry != 1)
	END
	ELSE IF @RegisteredFrom = 'CHC'
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
		FROM Tbl_SubjectPrimaryDetail SP
		LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.ID  = SP.ID
		LEFT JOIN Tbl_SubjectTypeMaster ST WITH (NOLOCK) ON ST.ID = SP.SubjectTypeID 
		WHERE SP.CHCID = @CHCID 
			AND (SP.[DateofRegister] BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103))
			AND (@SubjectType = 0 OR SP.[ChildSubjectTypeID] = @SubjectType)
			AND SP.[RegisteredFrom] = @RegisterFrom
			AND SP.[ID] NOT IN (SELECT SubjectID FROM Tbl_SampleCollection WHERE SampleDamaged != 1 AND SampleTimeoutExpiry != 1)
	END
END
      
