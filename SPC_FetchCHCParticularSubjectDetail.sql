USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_FetchCHCParticularSubjectDetail' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchCHCParticularSubjectDetail 
End
GO
CREATE PROCEDURE [dbo].[SPC_FetchCHCParticularSubjectDetail]
(
	@UserId INT
	,@UniqueSubjectID VARCHAR(200)
)AS
DECLARE @CHCID INT , @RegisterdFrom INT 
BEGIN
	 SET @CHCID =  (SELECT CHCID FROM Tbl_UserMaster WHERE ID = @UserId)
	 SET @RegisterdFrom = (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'CHC' AND comments = 'RegisterFrom')  
	 SELECT CASE WHEN ISNULL(SPRD.[DateofRegister],'') = '' THEN '' 
			 ELSE CONVERT(VARCHAR,SPRD.[DateofRegister],103)
			 END  AS  [DateofRegister]
			 ,(SELECT CommonName FROM Tbl_ConstantValues WHERE ID = SPRD.[RegisteredFrom]) AS RegisterBy
			,SPRD.[ID] 
			,SPRD.[SubjectTypeID]
			,STM.[SubjectType]  AS ChildSubjectType
			,SPRD.[ChildSubjectTypeID]
			,STM1.[SubjectType]
			,SPRD.[UniqueSubjectID]
			,SPRD.[DistrictID]
			,DM.[Districtname] 
			,SPRD.[CHCID]
			,CM.[CHCname] 
			,SPRD.[PHCID]
			,PM.[PHCname] 
			,SPRD.[SCID]
			,SM.[SCname] 
			,SPRD.[RIID]
			,RIM.[RIsite] 
			,SPRD.[SubjectTitle]
			,SPRD.[FirstName]
			,SPRD.[MiddleName]
			,SPRD.[LastName]
			,CASE WHEN ISNULL(SPRD.[DOB],'') = '' THEN '' 
			 ELSE CONVERT(VARCHAR,SPRD.[DOB],103)
			 END  AS  [DOB]
			,SPRD.[Age]
			,SPRD.[Gender]
			,SPRD.[MaritalStatus]
			,SPRD.[MobileNo]
			,SPRD.[EmailId]
			,SPRD.[SpouseSubjectID]
			,SPRD.[Spouse_FirstName]
			,SPRD.[Spouse_MiddleName]
			,SPRD.[Spouse_LastName]
			,SPRD.[Spouse_ContactNo]
			,SPRD.[GovIdType_ID]
			,GIM .[GovIDType]
			,SPRD.[GovIdDetail]
			,SPRD.[AssignANM_ID]
			,(UM.[User_gov_code]+ ' - ' + UM.[FirstName] + ' ' + UM.[MiddleName]  + ' ' + UM.[LastName]) AS ANMName
			,SPRD.[IsActive]
			,SAD.[SubjectID] SADSubjectID
			,SAD.[Religion_Id]
			,RM.[Religionname]
			,SAD.[Caste_Id]
			,CAM.[Castename]
			,SAD.[Community_Id]
			,COM.[CommunityName]
			,SAD.[Address1]
			,SAD.[Address2]
			,SAD.[Address3]
			,SAD.[Pincode]
			,SAD.[StateName] 
			,SPD.[SubjectID] SPDSubjectId
			,SPD.[RCHID]
			,SPD.[ECNumber]
			,CASE WHEN ISNULL(SPD.[LMP_Date],'') = '' THEN '' 
			 ELSE CONVERT(VARCHAR,SPD.[LMP_Date],103)
			 END  AS  LMP_Date
			,(SELECT [dbo].[FN_CalculateGestationalAge](SPD.[SubjectID])) AS [Gestational_period]
			,SPD.[G]
			,SPD.[P]
			,SPD.[L]
			,SPD.[A]
			,(SELECT [dbo].[FN_FindBarcodesByUser](SPRD.[ID])) AS Barcodes
			,SPAD.[SubjectID] SPADSubjectID
			,SPAD.[Mother_FirstName]
			,SPAD.[Mother_MiddleName]
			,SPAD.[Mother_LastName]
			,SPAD.[Mother_ContactNo]
			,GIMM.[GovIDType] AS [Mother_GovID]
			,SPAD.[Father_FirstName]
			,SPAD.[Father_MiddleName]
			,SPAD.[Father_LastName]
			,SPAD.[Father_ContactNo]
			,GIMF.[GovIDType] AS [Father_GovID]
			,SPAD.[Gaurdian_FirstName]
			,SPAD.[Gaurdian_MiddleName]
			,SPAD.[Gaurdian_LastName]
			,SPAD.[Gaurdian_ContactNo]
			,GIMG.[GovIDType] AS [Gaurdian_GovID]
			,SPAD.[RBSKId]
			,SPAD.[SchoolName]
			,SPAD.[SchoolAddress1]
			,SPAD.[SchoolAddress2]
			,SPAD.[SchoolAddress3]
			,SPAD.[SchoolPincode]
			,SPAD.[SchoolCity]
			,SPAD.[SchoolState]
			,SPAD.[Standard]
			,SPAD.[Section]
			,SPAD.[RollNo]
			,CASE WHEN ISNULL(SPRD.[DateofRegister],'') = '' THEN '' 
			 ELSE SPRD.[DateofRegister]
			 END  AS  [RegisterDate]
			,(SELECT [dbo].[FN_FindResult](SPAD.[UniqueSubjectID],'CBC')) AS CBCTestResult
			,(SELECT [dbo].[FN_FindResult](SPAD.[UniqueSubjectID],'SST')) AS SSTestResult
			,(SELECT [dbo].[FN_FindResult](SPAD.[UniqueSubjectID],'HPLC')) AS HPLCTestResult
	FROM [dbo].[Tbl_SubjectPrimaryDetail] AS SPRD
	LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] STM WITH (NOLOCK) ON STM.[ID] = SPRD.[SubjectTypeID]
	LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] STM1 WITH (NOLOCK) ON STM1.[ID] = SPRD.[ChildSubjectTypeID]
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK) ON DM.[ID] = SPRD.[DistrictID]
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.[ID] = SPRD.[CHCID]
	LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK) ON PM.[ID] = SPRD.[PHCID]
	LEFT JOIN [dbo].[Tbl_SCMaster] SM WITH (NOLOCK) ON SM.[ID] = SPRD.[SCID]
	LEFT JOIN [dbo].[Tbl_RIMaster] RIM WITH (NOLOCK) ON RIM.[ID] = SPRD.[RIID] 
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = SPRD.[AssignANM_ID]
	LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectParentDetail] SPAD WITH (NOLOCK) ON SPAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_ReligionMaster] RM WITH (NOLOCK) ON RM.[ID] = SAD.[Religion_Id]  
	LEFT JOIN [dbo].[Tbl_CasteMaster] CAM WITH (NOLOCK) ON CAM.[ID] = SAD.[Caste_Id]   
	LEFT JOIN [dbo].[Tbl_Gov_IDTypeMaster] GIM WITH (NOLOCK) ON GIM.[ID] = SPRD.[GovIdType_ID]    
	LEFT JOIN [dbo].[Tbl_Gov_IDTypeMaster] GIMF WITH (NOLOCK) ON GIMF.[ID] = SPAD.[Father_GovIdType_ID]  
	LEFT JOIN [dbo].[Tbl_Gov_IDTypeMaster] GIMM WITH (NOLOCK) ON GIMM.[ID] = SPAD.[Mother_GovIdType_ID]      
	LEFT JOIN [dbo].[Tbl_Gov_IDTypeMaster] GIMG WITH (NOLOCK) ON GIMG.[ID] = SPAD.[Guardian_GovIdType_ID]       
	LEFT JOIN [dbo].[Tbl_CommunityMaster] COM WITH (NOLOCK) ON COM.[ID] = SAD.[Community_Id]    
	WHERE  [SPRD].CHCID  = @CHCID AND SPRD.[RegisteredFrom] = @RegisterdFrom   
	AND (SPRD.[UniqueSubjectID]  like '%'+ @UniqueSubjectID +'%' OR SPRD.[MobileNo]like '%'+ @UniqueSubjectID +'%' OR 
	SPD.[RCHID] like '%'+ @UniqueSubjectID +'%' OR SPRD.[FirstName] like '%'+ @UniqueSubjectID +'%' OR
	SPRD.[LastName] like '%'+ @UniqueSubjectID +'%' ) 
END