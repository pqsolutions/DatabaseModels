USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_FetchUserByType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchUserByType
End
GO
CREATE Procedure [dbo].[SPC_FetchUserByType](@UserTypeId int)
As
Begin
	SELECT 
			um.[UserType_ID]  
			,ut.[Usertype]
			,um.[UserRole_ID] 
			,ur.[Userrolename]
			,um.[User_gov_code]  
			,um.[Username]  
			,um.[Password]
			,um.[StateID]
			,s.[Statename]
			,um.[DistricID]
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
			,ri.[RIsite] 
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
	FROM [Eduquaydb].[dbo].[Tbl_UserMaster] um
	LEFT JOIN [Eduquaydb].[dbo].[Tbl_UserRoleMaster] ur WITH (NOLOCK) ON ur.ID = um.UserRole_ID
	LEFT JOIN [Eduquaydb].[dbo].[Tbl_UserTypeMaster] ut WITH (NOLOCK) ON ut.ID = um.UserType_ID
	LEFT JOIN [Eduquaydb].[dbo].[Tbl_StateMaster] s WITH (NOLOCK) ON s.ID = um.StateID
	LEFT JOIN [Eduquaydb].[dbo].[Tbl_DistrictMaster] d WITH (NOLOCK) ON d.ID = um.DistrictID
	INNER JOIN [Eduquaydb].[dbo].[Tbl_BlockMaster] b WITH (NOLOCK) ON b.ID = um.BlockID
	INNER JOIN [Eduquaydb].[dbo].[Tbl_CHCMaster] c WITH (NOLOCK) ON c.ID = um.CHCID
	INNER JOIN [Eduquaydb].[dbo].[Tbl_PHCMaster] p WITH (NOLOCK) ON p.ID = um.PHCID	
	INNER JOIN [Eduquaydb].[dbo].[Tbl_SCMaster] sc WITH (NOLOCK) ON sc.ID = um.SCID
	INNER JOIN [Eduquaydb].[dbo].[Tbl_RIMaster] ri WITH (NOLOCK) ON ri.ID = um.RIID
	INNER JOIN [Eduquaydb].[dbo].[Tbl_Gov-IDTypeMaster] gm WITH (NOLOCK) ON gm.ID = gm.GovIDType
	WHERE um.[UserType_ID] = @UserTypeId
End
