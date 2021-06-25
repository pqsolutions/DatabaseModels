--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchTestingCHCByBlock' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchTestingCHCByBlock 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchTestingCHCByBlock] (@Id INT)
AS BEGIN
 SELECT DISTINCT CMT.[ID]    
		,(CMT.[CHC_Gov_Code]  + ' - ' +  CMT.[CHCname]) AS name
 FROM   [dbo].[Tbl_CHCMaster] CM
 LEFT JOIN  [dbo].[Tbl_CHCMaster] CMT WITH (NOLOCK) ON CMT.[ID] = CM.[TestingCHCID]
 LEFT JOIN  [dbo].[Tbl_BlockMaster] BM WITH (NOLOCK) ON BM.[ID] = CM.[BlockID]
 WHERE CM.[TestingCHCID] IS NOT NULL AND CM.[BlockID] = @Id AND CM.[Isactive] = 1
END  