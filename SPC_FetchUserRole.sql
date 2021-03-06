USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchUserRole]    Script Date: 03/26/2020 00:14:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchUserRole' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchUserRole
End
GO
CREATE Procedure [dbo].[SPC_FetchUserRole] (@ID int)
as
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
	WHERE ur.ID = @ID		
End

