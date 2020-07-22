USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchLogisticsProvider' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchLogisticsProvider
END
GO
CREATE Procedure [dbo].[SPC_FetchLogisticsProvider] 
AS
BEGIN
	SELECT [ID]
		,[ProviderName]
	FROM [dbo].[Tbl_LogisticsProviderMaster] WHERE IsActive = 1 	
END

