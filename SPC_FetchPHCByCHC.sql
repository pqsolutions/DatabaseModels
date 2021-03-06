USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchPHCByCHC]    Script Date: 03/26/2020 00:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchPHCByCHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchPHCByCHC
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchPHCByCHC](@Id INT)
 AS BEGIN  
 SELECT P.[ID] AS Id
		,P.[PHCname] AS Name
 FROM [dbo].[Tbl_PHCMaster] P
 LEFT JOIN [dbo].[Tbl_CHCMaster] C WITH (NOLOCK) ON P.CHCID = C.ID  
 WHERE  P.[CHCID]  = @Id AND P.[Isactive] = 1
END  