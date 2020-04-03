USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllUserType]    Script Date: 03/26/2020 00:06:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllUserType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllUserType
End
GO
CREATE Procedure [dbo].[SPC_FetchAllUserType]
As
Begin
	SELECT [ID]
		 ,[Usertype]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_UserTypeMaster]
	Order by [ID]
End
