USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchRIBySC]    Script Date: 03/26/2020 00:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchRIBySC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchRIBySC
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchRIBySC] (@Id INT)
AS BEGIN
 SELECT R.[ID]    
  ,R.[RIsite] 
 FROM [dbo].[Tbl_RIMaster] R
 LEFT JOIN [dbo].[Tbl_SCMaster] S WITH (NOLOCK)ON S.ID = R.SCID
 WHERE  R.[SCID] = @Id AND R.[Isactive] = 1
END  