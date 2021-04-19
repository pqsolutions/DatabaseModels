--USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchILRByRI]    Script Date: 03/26/2020 00:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchILRByCHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchILRByCHC
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchILRByCHC] (@Id INT)
AS BEGIN
 SELECT I.[ID]    
		,(I.[ILRCode]  + ' - ' +  I.[ILRPoint]  ) AS name
 FROM [dbo].[Tbl_ILRMaster] I
 WHERE  I.CHCID  = @Id AND I.[Isactive] = 1
END  