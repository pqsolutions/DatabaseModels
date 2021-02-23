--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchDistrictsByPNDTLocation' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchDistrictsByPNDTLocation
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchDistrictsByPNDTLocation] 
(
	  @PNDTLocationId INT
)
AS
BEGIN
	SELECT  [Id]
		,[Districtname] AS Name
	FROM Tbl_DistrictMaster 
	WHERE PNDTLocationId = @PNDTLocationId 
END