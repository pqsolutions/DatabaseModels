USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_FetchSubjectDetail' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchSubjectDetail
End
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectDetail]
(
	@UniqueSubjectID VARCHAR(200)
)AS
BEGIN
	SELECT SPRD.[SubjectTypeID]
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
			,RM.[RIsite] 
			,SPRD.[FirstName]
			,SPRD.[MiddleName]
			,SPRD.[LastName]
			,SPRD.[DOB]
			,SPRD.[Age]
			,SPRD.[Gender]
			,SPRD.[MaritalStatus]
			,SPRD.[MobileNo]
			,SPRD.[SpouseSubjectID]
			,SPRD.[Spouse_FirstName]
			,SPRD.[Spouse_MiddleName]
			,SPRD.[Spouse_LastName]
			,SPRD.[Spouse_ContactNo]
			,SPRD.[GovIdType_ID]
			,SPRD.[GovIdDetail]
			,SPRD.[AssignANM_ID]
			,(UM.[User_gov_code]+ ' - ' + UM.[FirstName] +' '+ UM.[MiddleName]  +' '+ UM.[LastName]) AS ANMName
			,SPRD.[IsActive]
			,SAD.[Religion_Id]
			,SAD.[Caste_Id]
			,SAD.[Community_Id]
			,SAD.[Address1]
			,SAD.[Address2]
			,SAD.[Address3]
			,SAD.[Pincode]
			,SPD.[RCHID]
			,SPD.[ECNumber]
			,SPD.[LMP_Date]
			,SPD.[Gestational_period]
			,SPD.[G]
			,SPD.[P]
			,SPD.[L]
			,SPD.[A]
			,SPAD.[Mother_FirstName]
			,SPAD.[Mother_MiddleName]
			,SPAD.[Mother_LastName]
			,SPAD.[Mother_UniquetID]
			,SPAD.[Mother_ContactNo]
			,SPAD.[Father_FirstName]
			,SPAD.[Father_MiddleName]
			,SPAD.[Father_LastName]
			,SPAD.[Father_UniquetID]
			,SPAD.[Father_ContactNo]
			,SPAD.[Gaurdian_FirstName]
			,SPAD.[Gaurdian_MiddleName]
			,SPAD.[Gaurdian_LastName]
			,SPAD.[Gaurdian_ContactNo]
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
	FROM [dbo].[Tbl_SubjectPrimaryDetail] AS SPRD
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK) ON DM.[ID] = SPRD.[DistrictID]
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.[ID] = SPRD.[CHCID]
	LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK) ON PM.[ID] = SPRD.[PHCID]
	LEFT JOIN [dbo].[Tbl_SCMaster] SM WITH (NOLOCK) ON SM.[ID] = SPRD.[SCID]
	LEFT JOIN [dbo].[Tbl_RIMaster] RM WITH (NOLOCK) ON RM.[ID] = SPRD.[RIID] 
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = SPRD.[AssignANM_ID]
	LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectParentDetail] SPAD WITH (NOLOCK) ON SPAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID]
	WHERE  SPRD.[UniqueSubjectID] = @UniqueSubjectID	
END