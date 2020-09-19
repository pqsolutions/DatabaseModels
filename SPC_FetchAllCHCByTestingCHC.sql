USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllCHCByTestingCHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllCHCByTestingCHC 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllCHCByTestingCHC] (@TestingCHCId INT)

AS
BEGIN
	SELECT [ID] 
		,[CHCName]
	FROM [dbo].[Tbl_CHCMaster]  
	WHERE IsActive = 1 AND  TestingCHCID = @TestingCHCId 
	
END