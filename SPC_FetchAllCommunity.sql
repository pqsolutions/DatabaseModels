USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllCommunity' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllCommunity
End
GO
CREATE Procedure [dbo].[SPC_FetchAllCommunity]
As
Begin
	SELECT CO.[ID]
		 ,CO.[CasteID] 
		 ,CA.[Castename] 
		 ,CO.[Communityname]	
		 ,CO.[Isactive]
		 ,CO.[Comments] 
		 ,CO.[Createdby] 
		 ,CO.[Updatedby]      
	FROM [dbo].[Tbl_CommunityMaster] CO
	LEFT JOIN [dbo].[Tbl_CasteMaster] CA WITH (NOLOCK) ON CA.[ID] = CO.[CasteID] 
	Order by [ID]
End
