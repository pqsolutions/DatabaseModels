USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAVDByRI' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAVDByRI
END
GO
CREATE Procedure [dbo].[SPC_FetchAVDByRI] (@Id VARCHAR(10))
AS
BEGIN
	SELECT A.[ID]
		,A.[AVDName]
		,A.[ContactNo] 
	FROM [dbo].[Tbl_AVDMaster] A	
	WHERE  A.[Isactive] = 1 AND '1' = [dbo].[FN_TableToColumn] (A.[RIID],',',@Id,'contains')
END

