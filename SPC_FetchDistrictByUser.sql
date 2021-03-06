USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchDistrictByUser]    Script Date: 03/26/2020 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchDistrictByUser' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchDistrictByUser
END
GO
CREATE Procedure [dbo].[SPC_FetchDistrictByUser] (@UserId INT)
AS
BEGIN
	SELECT D.[ID]
		,(D.[District_gov_code] + ' - ' + D.[Districtname]) AS  Districtname
		,D.[District_gov_code] 	
	FROM [dbo].[Tbl_DistrictMaster] D
	LEFT JOIN [dbo].[Tbl_UserMaster] U WITH (NOLOCK) ON D.ID = U.DistrictID	
	WHERE U.ID = @UserId AND D.[Isactive] = 1
END

