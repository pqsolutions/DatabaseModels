--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllMutation' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllMutation
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllMutation] 

AS
BEGIN
	SELECT [ID] AS Id
		,[Mutation] AS Name
	FROM Tbl_MutationMaster ORDER BY ID 
	
END

