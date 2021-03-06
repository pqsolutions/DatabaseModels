USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCommunityByCaste' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCommunityByCaste
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchCommunityByCaste] (@ID INT)
AS
BEGIN
	SELECT  CO.[ID]
		 ,CO.[CasteID] 
		 ,CA.[Castename] 
		 ,CO.[Communityname]	
		 ,CO.[Isactive]
		 ,CO.[Comments] 
		 ,CO.[Createdby] 
		 ,CO.[Updatedby]      
	FROM [dbo].[Tbl_CommunityMaster] CO
	LEFT JOIN [dbo].[Tbl_CasteMaster] CA WITH (NOLOCK) ON CA.[ID] = CO.[CasteID] 
	WHERE CO.[ID] = @ID		 
END

