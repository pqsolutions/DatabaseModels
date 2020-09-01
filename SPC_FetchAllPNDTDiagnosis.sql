USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllPNDTDiagnosis' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllPNDTDiagnosis 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllPNDTDiagnosis] 

AS
BEGIN
	SELECT [ID] AS Id
		,[DiagnosisName] AS Name
	FROM Tbl_PNDTDiagnosisMaster 
	
END