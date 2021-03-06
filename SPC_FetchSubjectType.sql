
USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_FetchSubjectType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchSubjectType
End
GO

Create Procedure [dbo].[SPC_FetchSubjectType](@ID int)
As
Begin
	SELECT [ID]
		 ,[SubjectType]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_SubjectTypeMaster]
	WHERE [ID] = @ID
End
