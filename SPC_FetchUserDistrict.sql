USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchUserDistrict' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchUserDistrict 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchUserDistrict] 
(
	  @UserId INT
)
AS
BEGIN
	SELECT UD.[DistrictID] AS Id
		,DM.[Districtname] AS Name
	FROM Tbl_UserDistrictMaster UD
	LEFT JOIN Tbl_DistrictMaster DM WITH (NOLOCK) ON DM.[ID] = UD.[DistrictId]
	WHERE UD.[UserId] = @UserId 
END