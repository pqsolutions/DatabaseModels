USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchState]    Script Date: 03/26/2020 00:13:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_FetchState' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchState
End
GO
CREATE Procedure [dbo].[SPC_FetchState] (@ID int)
as
Begin
	SELECT [ID]
		 ,[Statename]
		 ,[Shortname]
		 ,[State_gov_code]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_StateMaster] where ID = @ID		
End

