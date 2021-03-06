--USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchSCByPHC]    Script Date: 03/26/2020 00:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSCByPHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSCByPHC
END
GO
CREATE  PROCEDURE [dbo].[SPC_FetchSCByPHC] (@Id INT)
AS BEGIN  
 SELECT S.[ID]  
		,(S.[SC_gov_code] + '-' +  S.[SCname] )AS name
 FROM [dbo].[Tbl_SCMaster] S  
 --LEFT JOIN [dbo].[Tbl_PHCMaster] P WITH (NOLOCK) ON S.PHCID = P.ID 
 WHERE S.[PHCID] = @Id AND S.[Isactive] = 1
END  