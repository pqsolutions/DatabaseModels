USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllUserRole]    Script Date: 03/26/2020 00:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllUserRole' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllUserRole
End
GO
CREATE Procedure [dbo].[SPC_FetchAllUserRole]
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
	FROM [dbo].[Tbl_UserRoleMaster] ur
	LEFT JOIN [dbo].[Tbl_UserTypeMaster] ut WITH (NOLOCK) ON ut.ID = ur.UsertypeID
	Order by ur.[ID]
End
