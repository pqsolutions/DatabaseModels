USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCentralLabSampleStatus' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCentralLabSampleStatus 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchCentralLabSampleStatus] 

AS
BEGIN
	SELECT [ID] 
		,[StatusName]
	FROM [dbo].[Tbl_CentralLabSampleStatusMaster] WHERE IsActive = 1
	
END