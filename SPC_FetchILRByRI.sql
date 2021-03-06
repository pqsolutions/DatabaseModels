USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchILRByRI]    Script Date: 03/26/2020 00:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchILRByRI' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchILRByRI
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchILRByRI] (@Id INT)
AS BEGIN
 SELECT I.[ID]    
		,(I.[ILRCode]  + ' - ' +  I.[ILRPoint]  ) AS [ILRPoint]
 FROM [dbo].[Tbl_ILRMaster] I
 LEFT JOIN [dbo].[Tbl_RIMaster] R WITH (NOLOCK)ON R.ILRID = I.ID
 WHERE  R.[ILRID]  = @Id AND R.[Isactive] = 1
END  