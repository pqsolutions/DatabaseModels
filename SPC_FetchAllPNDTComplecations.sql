USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllPNDTComplecations' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllPNDTComplecations 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllPNDTComplecations] 

AS
BEGIN
	SELECT [ID] AS Id
		,[ComplecationsName] AS Name
	FROM Tbl_PNDTComplicationsMaster 
	
END