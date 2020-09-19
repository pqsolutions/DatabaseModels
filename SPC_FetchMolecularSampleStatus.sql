USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMolecularSampleStatus' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMolecularSampleStatus 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMolecularSampleStatus] 

AS
BEGIN
	SELECT [ID] 
		,[StatusName]
	FROM [dbo].[Tbl_MolecularSampleStatusMaster] WHERE IsActive = 1
	
END