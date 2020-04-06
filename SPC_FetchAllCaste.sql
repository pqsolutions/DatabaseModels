USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllCaste' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllCaste
End
GO
CREATE Procedure [dbo].[SPC_FetchAllCaste]
As
Begin
	SELECT [ID]
		 ,[Castename]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_CasteMaster]
	Order by [ID]
End
