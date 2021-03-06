USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchCaste' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchCaste
End
GO
CREATE Procedure [dbo].[SPC_FetchCaste] (@ID int)
as
Begin
	SELECT [ID]
		 ,[Castename]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_CasteMaster] where ID = @ID		
End

