USE Eduquaydb
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileMetricsReportMessage' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileMetricsReportMessage 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobileMetricsReportMessage] 
AS 
BEGIN 
	SELECT Comments
	FROM Tbl_ConstantValues WHERE ID = 12 
END