--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllPNDTLocation' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllPNDTLocation 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllPNDTLocation] 

AS
BEGIN
	SELECT [ID] AS Id
		,[PNDTLocationName] AS Name
	FROM Tbl_PNDTLocationMaster ORDER BY [PNDTLocationName]
	
END