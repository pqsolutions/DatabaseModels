USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchUserType]    Script Date: 03/26/2020 00:15:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchUserType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchUserType
End
GO
CREATE Procedure [dbo].[SPC_FetchUserType] (@ID int)
as
Begin
	SELECT [ID]
		 ,[Usertype]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_UserTypeMaster] where ID = @ID		
End

