USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER Procedure [dbo].[SPC_FetchAllUserRole]
As
Begin
	SELECT ur.[ID]
		 ,ur.[UsertypeID]
		 ,ut.[Usertype]
		 ,ur.[Userrolename]	
		 ,ur.[Isactive]
		 ,ur.[Comments] 
		 ,ur.[Createdby] 
		 ,ur.[Updatedby]      
	FROM [Eduquaydb].[dbo].[Tbl_UserRoleMaster] ur
	LEFT JOIN [Eduquaydb].[dbo].[Tbl_UserTypeMaster] ut WITH (NOLOCK) ON ut.ID = ur.UsertypeID
	Order by ur.[ID]
End
