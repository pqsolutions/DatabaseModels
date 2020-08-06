USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCentralLabByCHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCentralLabByCHC
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchCentralLabByCHC] (@Id INT)
AS BEGIN
 SELECT C.[ID]    
		,(C.[CentralLabName]) AS [CentralLab]
 FROM   [dbo].[Tbl_CentralLabMaster] C
 LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON C.[ID] = CM.[CentralLabId] 
 WHERE C.[ID] = @ID
END  