USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchWebConstantData]    Script Date: 03/26/2020 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchWebConstantData' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchWebConstantData
END
GO
CREATE Procedure [dbo].[SPC_FetchWebConstantData](@UserId INT)
AS
BEGIN
	DECLARE @UserType INT
	SET @UserType = (SELECT UserType_ID  FROM Tbl_UserMaster WHERE ID=@UserId )
	IF @UserType = 1
	BEGIN
	SELECT (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'ANM' AND comments = 'RegisterFrom') AS RegisteredFrom
			,(SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'ANM' AND comments = 'SampleCollectionFrom') AS SampleCollectionFrom
			, (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'ANM - CHC' AND comments = 'ShipmentFrom') AS ShipmentFrom
	END
	ELSE IF @UserType = 2
	BEGIN
		SELECT (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'CHC' AND comments = 'RegisterFrom') AS RegisteredFrom
			,(SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'CHC' AND comments = 'SampleCollectionFrom') AS SampleCollectionFrom
			, (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'CHC - CHC' AND comments = 'ShipmentFrom') AS ShipmentFrom
	END
	

END

