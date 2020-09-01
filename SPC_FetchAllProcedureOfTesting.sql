USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllProcedureOfTesting' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllProcedureOfTesting 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllProcedureOfTesting] 

AS
BEGIN
	SELECT [ID] AS Id
		,[ProcedureName] AS Name
	FROM Tbl_PNDTProcedureOfTestingMaster 
	
END