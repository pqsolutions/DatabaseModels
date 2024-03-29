--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_FetchUserByUsername' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchUserByUsername
End
GO
CREATE Procedure [dbo].[SPC_FetchUserByUsername](@Username varchar(150))
As
Begin
	SELECT  um.[ID]
			,um.[UserType_ID]  
			,ut.[Usertype]
			,um.[UserRole_ID] 
			,ur.[Userrolename]
			,ur.[Descriptions] UserRoleDescription
			,ur.[AccessModules]
			,um.[User_gov_code]  
			,um.[Username]  
			,um.[Password]
			,um.[StateID]
			,s.[Statename]
			,um.[CentralLabId]
			,cl.[CentralLabName]
			,um.[molecularLabId]
			,ml.[MLabName]
			,s.[Shortname]
			,um.[DistrictID]
			,d.[Districtname] 
			,ISNULL(um.[BlockId],0)AS BlockID
			,b.[Blockname]
			,ISNULL(um.[CHCID],0) AS CHCID
			,c.[CHCname]
			,ISNULL(um.[PHCID],0)AS PHCID
			,p.[PHCname] 
			,ISNULL(um.[SCID],0) AS SCID
			,sc.[SCname]
			,ISNULL(um.[RIID],0) AS RIID
			--,ri.[RIsite] 
			,CASE WHEN um.[UserRole_ID] = 6 THEN
			(um.[FirstName] + ' ' + um.[LastName] +'/'+c.[CHCname]+'/'+d.[Districtname])
			ELSE (um.[FirstName] + ' ' + um.[LastName]) END AS Name 
			,um.[FirstName]
			,um.[MiddleName]
			,um.[LastName] 
			,um.[ContactNo1] 
			,um.[ContactNo2]
			,um.[Email]
			,ISNULL(um.[GovIDType_ID],0) AS GovIDType_ID
			,gm.[GovIDType]
			,um.[GovIDDetails]
			,um.[Address]
			,um.[Pincode] 
			,um.[Createdby]
			,um.[Updatedby]
			,um.[Comments] 
			,um.[Isactive] 
			,um.[DigitalSignature]
			,um.[PNDTLocationId]
			,CASE WHEN ut.[Usertype] = 'ANM' OR ut.[Usertype] = 'NHM' THEN (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'ANM' AND comments = 'RegisterFrom')
				ELSE (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'CHC' AND comments = 'RegisterFrom')END AS RegisteredFrom
			,CASE WHEN ut.[Usertype] = 'ANM' OR ut.[Usertype] = 'NHM' THEN (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'ANM' AND comments = 'SampleCollectionFrom')
				ELSE (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'CHC' AND comments = 'SampleCollectionFrom') END AS SampleCollectionFrom
			,CASE WHEN ut.[Usertype] = 'ANM' OR ut.[Usertype] = 'NHM' THEN (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'ANM - CHC' AND comments = 'ShipmentFrom')
				ELSE (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'CHC - CHC' AND comments = 'ShipmentFrom') END AS ShipmentFrom     
	FROM [dbo].[Tbl_UserMaster] um
	LEFT JOIN [dbo].[Tbl_UserRoleMaster] ur WITH (NOLOCK) ON ur.ID = um.UserRole_ID
	LEFT JOIN [dbo].[Tbl_UserTypeMaster] ut WITH (NOLOCK) ON ut.ID = um.UserType_ID
	LEFT JOIN [dbo].[Tbl_StateMaster] s WITH (NOLOCK) ON s.ID = um.StateID
	LEFT JOIN [dbo].[Tbl_CentralLabMaster] cl WITH (NOLOCK) ON cl.ID = um.CentralLabId
	LEFT JOIN [dbo].[Tbl_DistrictMaster] d WITH (NOLOCK) ON d.ID = um.DistrictID
	LEFT JOIN [dbo].[Tbl_BlockMaster] b WITH (NOLOCK) ON b.ID = um.BlockID
	LEFT JOIN [dbo].[Tbl_CHCMaster] c WITH (NOLOCK) ON c.ID = um.CHCID
	LEFT JOIN [dbo].[Tbl_PHCMaster] p WITH (NOLOCK) ON p.ID = um.PHCID	
	LEFT JOIN [dbo].[Tbl_SCMaster] sc WITH (NOLOCK) ON sc.ID = um.SCID
	--LEFT JOIN [dbo].[Tbl_RIMaster] ri WITH (NOLOCK) ON ri.ID = um.RIID
	LEFT JOIN [dbo].[Tbl_Gov_IDTypeMaster] gm WITH (NOLOCK) ON gm.ID = um.GovIDType_ID
	LEFT JOIN [dbo].[Tbl_MolecularLabMaster] ml WITH (NOLOCK) ON ml.ID = um.MolecularLabId
	
	WHERE um.[Username] = @Username AND um.[IsActive] = 1
End
