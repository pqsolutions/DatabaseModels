USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchTestingCHCByRI]    Script Date: 03/26/2020 00:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchTestingCHCByRI' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchTestingCHCByRI 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchTestingCHCByRI] (@Id INT)
AS BEGIN
 SELECT C.[ID]    
		,(C.[CHC_Gov_Code]  + ' - ' +  C.[CHCname]) AS [CHCName]
 FROM   [dbo].[Tbl_RIMaster] R
 LEFT JOIN[dbo].[Tbl_CHCMaster] C  WITH (NOLOCK)ON R.TestingCHCID = C.ID
 WHERE R.[ID] = @ID
END  