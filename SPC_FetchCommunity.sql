USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchCommunity' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchCommunity
End
GO
CREATE Procedure [dbo].[SPC_FetchCommunity] (@ID int)
as
Begin
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
	where CO.[ID] = @ID		 
End

