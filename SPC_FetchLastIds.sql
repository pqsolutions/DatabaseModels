USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchLastIds' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchLastIds
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchLastIds]
(	
	@ANMId INT
)
AS 
	DECLARE @LastSubjectId VARCHAR(250)
			,@LastShipmentId VARCHAR(250)
BEGIN
	SET @LastSubjectId = (SELECT [dbo].[FN_FindLastUniqueSubjectId](@ANMId))
	SET @LastShipmentId = (SELECT [dbo].[FN_FindLastANMShipmentId]  (@ANMId))
	SELECT @LastSubjectId AS LastSubjectId, @LastShipmentId AS LastShipmentId
END 
