USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllMTPDischarge' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllMTPDischarge 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllMTPDischarge] 

AS
BEGIN
	SELECT [ID] AS Id
		,[DischargeConditionName]  AS Name
	FROM Tbl_DischargeConditionMaster  
	
END