USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchReligion' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchReligion
End
GO
CREATE Procedure [dbo].[SPC_FetchReligion] (@ID int)
as
Begin
	SELECT [ID]
		 ,[Religionname]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_ReligionMaster] where ID = @ID		
End

