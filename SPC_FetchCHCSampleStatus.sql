USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCHCSampleStatus' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCHCSampleStatus 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchCHCSampleStatus] 

AS
BEGIN
	SELECT [ID] 
		,[StatusName]
	FROM [dbo].[Tbl_CHCSampleStatusMaster] WHERE IsActive = 1
	
END