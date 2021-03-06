USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchMobileConstantData]    Script Date: 03/26/2020 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileConstantData' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileConstantData
END
GO
CREATE Procedure [dbo].[SPC_FetchMobileConstantData]
AS
BEGIN
	SELECT (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'ANM' AND comments = 'RegisterFrom') AS RegisteredFrom
			,(SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'ANM' AND comments = 'SampleCollectionFrom') AS SampleCollectionFrom
			, (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'ANM - CHC' AND comments = 'ShipmentFrom') AS ShipmentFrom
END

