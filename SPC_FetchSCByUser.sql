USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchSCByUser]    Script Date: 03/26/2020 00:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSCByUser' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSCByUser
END
GO
CREATE  PROCEDURE [dbo].[SPC_FetchSCByUser] (@UserId INT)
AS BEGIN  
 SELECT S.[ID]  
		,(S.[SC_gov_code] + ' - ' +  S.[SCname] )AS [SCname]
		,S.[SC_gov_code] 
 FROM [dbo].[Tbl_SCMaster] S  
 LEFT JOIN [dbo].[Tbl_UserMaster] U WITH (NOLOCK) ON U.SCID = S.ID 
 WHERE U.[ID] = @UserId AND S.[Isactive] = 1
END  