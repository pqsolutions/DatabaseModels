USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchPathologistSampleStatus' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchPathologistSampleStatus 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchPathologistSampleStatus] 

AS
BEGIN
	SELECT [ID] 
		,[StatusName]
	FROM [dbo].[Tbl_PathologistSampleStatusMaster] WHERE IsActive = 1
	
END