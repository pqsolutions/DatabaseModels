USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchDistrict]    Script Date: 03/26/2020 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchDistrictByUser' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchDistrictByUser
END
GO
CREATE Procedure [dbo].[SPC_FetchDistrictByUser] (@ID int)
AS
BEGIN
	SELECT D.[ID]
		
		,D.[Districtname]
		
		     
	FROM [dbo].[Tbl_DistrictMaster] D
	LEFT JOIN [dbo].[Tbl_StateMaster] S WITH (NOLOCK) ON S.ID = D.StateID	
	WHERE D.ID = @ID		
END

