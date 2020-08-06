USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMolecularLabLabByCentralLab' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMolecularLabLabByCentralLab
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMolecularLabLabByCentralLab] (@Id INT)
AS BEGIN
 SELECT M.[ID]    
		,(M.[MLabName]) AS MolecularLabName
 FROM   [dbo].[Tbl_MolecularLabMaster] M
 LEFT JOIN [dbo].[Tbl_CentralLabMaster] C WITH (NOLOCK) ON C.[MolecularLabId] = M.[ID]  
 WHERE M.[ID] = @ID
END  