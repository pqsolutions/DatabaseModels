USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllPNDTResultMaster' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllPNDTResultMaster
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllPNDTResultMaster] 

AS
BEGIN
	SELECT [ID] AS Id
		,[ResultName]  AS Name
	FROM Tbl_PNDTResultMaster 
	
END