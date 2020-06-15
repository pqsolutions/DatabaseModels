USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchCHCByDistrict]    Script Date: 03/26/2020 00:08:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCHCByDistrict' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCHCByDistrict
END
GO
CREATE Procedure [dbo].[SPC_FetchCHCByDistrict] (@Id INT)
AS
BEGIN
	SELECT C.[ID]
		,C.[CHCname]
	FROM [dbo].[Tbl_CHCMaster] C
	LEFT JOIN [dbo].[Tbl_DistrictMaster] D WITH (NOLOCK) ON C.DistrictID  = D.ID
	WHERE C.DistrictID = @Id AND C.[Isactive] = 1
END

