USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchRIByUser]    Script Date: 03/26/2020 00:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchRIByUser' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchRIByUser
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchRIByUser] (@UserId INT)
AS BEGIN
 SELECT R.[ID]    
  ,R.[RIsite] 
 FROM [dbo].[Tbl_RIMaster] R
 WHERE  R.[ID] IN (SELECT Value from dbo.[FN_Split]((SELECT isnull(RIID,'') FROM Tbl_UserMaster WHERE ID = @UserId),',')) AND R.[Isactive] = 1
END  