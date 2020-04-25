USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchTestType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchTestType
End
GO
CREATE PROCEDURE [dbo].[SPC_FetchTestType](@ID INT)
As
BEGIN
	SELECT [ID]
		 ,[TestType]
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_TestTypeMaster] WHERE ID = @ID		
END

