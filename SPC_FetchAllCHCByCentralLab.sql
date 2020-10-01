USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllCHCByCentralLab' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllCHCByCentralLab 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllCHCByCentralLab] (@Id INT)

AS
BEGIN
	SELECT [ID] 
		,[CHCName]
	FROM [dbo].[Tbl_CHCMaster]  
	WHERE IsActive = 1 AND  CentralLabId  = @Id 
	
END