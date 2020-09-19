USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllMolecularResultMaster' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllMolecularResultMaster 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllMolecularResultMaster] 

AS
BEGIN
	SELECT [ID] 
		,[ResultName] 
	FROM Tbl_MolecularResultMaster 
	
END