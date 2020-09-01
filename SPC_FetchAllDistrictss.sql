USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllDistrictss' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllDistrictss 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllDistrictss] 

AS
BEGIN
	SELECT [ID] AS Id
		,[Districtname] AS Name
	FROM Tbl_DistrictMaster 
	
END