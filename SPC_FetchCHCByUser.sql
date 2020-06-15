USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchCHCByUser]    Script Date: 03/26/2020 00:08:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCHCByUser' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCHCByUser
END
GO
CREATE Procedure [dbo].[SPC_FetchCHCByUser] (@UserId INT)
AS
BEGIN
	SELECT C.[ID]
		,C.[CHCname]
	FROM [dbo].[Tbl_CHCMaster] C
	LEFT JOIN [dbo].[Tbl_UserMaster] U WITH (NOLOCK) ON U.CHCID = C.ID
	WHERE U.ID = @UserId AND C.[Isactive] = 1
END

