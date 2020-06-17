USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAssociatedANMByRI' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAssociatedANMByRI
END
GO
CREATE Procedure [dbo].[SPC_FetchAssociatedANMByRI] (@Id VARCHAR(10))
AS
BEGIN
	SELECT U.[ID]
		,(U.[User_gov_code] + ' - ' + U.[FirstName]  + ' ' + U.[MiddleName] + ' ' + U.[LastName])  AS ANMName
		,U.[User_gov_code] 
	FROM [dbo].[Tbl_UserMaster] U	
	WHERE  U.[Isactive] = 1 AND '1' = [dbo].[FN_TableToColumn] (U.[RIID],',',@Id,'contains')
END

