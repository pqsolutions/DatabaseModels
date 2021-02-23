--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllZygosity' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllZygosity 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllZygosity] 

AS
BEGIN
	SELECT [ID] AS Id
		,[ZygosityName] AS Name
	FROM Tbl_ZygosityMaster ORDER BY ID 
	
END
