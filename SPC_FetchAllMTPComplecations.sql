USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllMTPComplecations' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllMTPComplecations 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllMTPComplecations] 

AS
BEGIN
	SELECT [ID] AS Id
		,[ComplecationsName] AS Name
	FROM Tbl_MTPComplicationsMaster 
	
END