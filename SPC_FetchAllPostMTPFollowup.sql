USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllPostMTPFollowup' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllPostMTPFollowup 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllPostMTPFollowup] 

AS
BEGIN
	SELECT [ID] AS Id
		,[StatusName]  AS Name
	FROM Tbl_MTPFollowUpMaster  
	
END