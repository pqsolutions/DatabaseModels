USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchTestingCHCByCHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchTestingCHCByCHC
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchTestingCHCByCHC] (@Id INT)
AS BEGIN
 SELECT CM.[ID]    
		,(CM.[CHC_Gov_Code]  + ' - ' +  CM.[CHCname]) AS [CHCName]
 FROM   [dbo].[Tbl_CHCMaster] C
 LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON C.[TestingCHCID] = CM.[ID]
 WHERE C.[ID] = @ID
END  