USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchTestType' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchTestType
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchTestType](@ID INT)
AS
BEGIN
	SELECT [ID]
		 ,[TestType]
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_TestTypeMaster] WHERE ID = @ID		
END

