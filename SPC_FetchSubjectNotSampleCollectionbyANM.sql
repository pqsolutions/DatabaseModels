USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details not collected Sample of particular ANM

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectNotSampleCollectionbyANM' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectNotSampleCollectionbyANM
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectNotSampleCollectionbyANM] 
(
	@ANMID INT
	,@FromDate VARCHAR(50)
	,@ToDate VARCHAR(50)
	,@SubjectType INT
)
AS
BEGIN
	SELECT SP.[ID]
      ,SP.[UniqueSubjectID]
      ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
      ,SP.[SubjectTypeID]
      ,ST.[SubjectType]  
      ,(CONVERT(VARCHAR,SP.[DateofRegister],105)) AS  DateofRegister
      ,SP.[MobileNo] AS ContactNo
      ,(SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) AS GestationalAge
      FROM Tbl_SubjectPrimaryDetail SP
      LEFT JOIN Tbl_SubjectTypeMaster ST WITH (NOLOCK) ON ST.ID = SP.SubjectTypeID 
      WHERE SP.[CreatedBy] = @ANMID  
			AND (SP.[DateofRegister] BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103))
			AND (@SubjectType = 0 OR SP.[SubjectTypeID] = @SubjectType)
			AND SP.[ID] NOT IN (SELECT SubjectID FROM Tbl_SampleCollection WHERE CollectedBy = @ANMID 
								AND BarcodeDamaged != 1 AND SampleDamaged != 1 AND SampleTimeoutExpiry != 1)
END
      
