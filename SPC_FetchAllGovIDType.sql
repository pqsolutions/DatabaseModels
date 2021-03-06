USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllGovIDType' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllGovIDType
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllGovIDType]
AS
BEGIN
	SELECT [ID]
		 ,[GovIDType]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_Gov_IDTypeMaster]
	UNION ALL
	SELECT 0 AS ID, 'N/A' AS GOVIDType, 1 AS Isactive,'' AS Comments,1 as CreatedBy,GETDATE() AS UpdatedBy 
	ORDER BY [ID]
END
