USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchUserByLogin' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchUserByLogin 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchUserByLogin](@Username VARCHAR(250))
As
Begin
	SELECT  um.[ID]
			,um.[UserType_ID]  
			,um.[UserRole_ID] 
			,um.[User_gov_code]  
			,um.[Username]  
			,um.[StateID]
			,um.[DistrictID]
			,ISNULL(um.[BlockId],0)AS BlockID
			,ISNULL(um.[CHCID],0) AS CHCID
			,ISNULL(um.[PHCID],0)AS PHCID
			,ISNULL(um.[SCID],0) AS SCID
			,ISNULL(um.[RIID],0) AS RIID
			,um.[Username]
			,(um.[FirstName] + ' ' + um.[MiddleName] + ' ' + um.[LastName]) AS Name
			,um.[Email]
			,ISNULL(um.[DigitalSignature],'') AS DigitalSignature
			,CASE WHEN UserType_ID =1 THEN (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'ANM' AND comments = 'RegisterFrom')
				ELSE (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'CHC' AND comments = 'RegisterFrom')END AS RegisteredFrom
			,CASE WHEN UserType_ID =1 THEN (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'ANM' AND comments = 'SampleCollectionFrom')
				ELSE (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'CHC' AND comments = 'SampleCollectionFrom') END AS SampleCollectionFrom
			,CASE WHEN UserType_ID =1 THEN (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'ANM - CHC' AND comments = 'ShipmentFrom')
				ELSE (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'CHC - CHC' AND comments = 'ShipmentFrom') END AS ShipmentFrom
	FROM [dbo].[Tbl_UserMaster] um
	WHERE (um.[Username] = @Username OR um.[Email] = @Username ) AND um.[IsActive] = 1
END
