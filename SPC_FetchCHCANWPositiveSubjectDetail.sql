USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_FetchCHCANWPositiveSubjectDetail' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchCHCANWPositiveSubjectDetail 
End
GO
CREATE PROCEDURE [dbo].[SPC_FetchCHCANWPositiveSubjectDetail]
(
	@CHCId INT
	,@FromDate VARCHAR(50)
	,@ToDate VARCHAR(50)
)AS
BEGIN
	DECLARE @StartDate VARCHAR(50), @EndDate VARCHAR(50)
	IF @FromDate = NULL OR @FromDate = ''
	BEGIN
		SET @StartDate = (SELECT CONVERT(VARCHAR,DATEADD(YEAR ,-1,GETDATE()),103))
	END
	ELSE
	BEGIN
		SET @StartDate = @FromDate
	END
	IF @ToDate = NULL OR @ToDate = ''
	BEGIN
		SET @EndDate = (SELECT CONVERT(VARCHAR,GETDATE(),103))
	END
	ELSE
	BEGIN
		SET @EndDate = @ToDate
	END

	SELECT SPRD.[ID] 
			,SPRD.[SubjectTypeID]
			,STM.[SubjectType]
			,SPRD.[ChildSubjectTypeID]
			,STM1.[SubjectType] AS ChildSubjectType
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
			,CASE WHEN ISNULL(SPRD.[DateofRegister],'') = '' THEN '' 
			 ELSE CONVERT(VARCHAR,SPRD.[DateofRegister],103)
			 END  AS  [DateofRegister]
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
			,(SELECT [dbo].[FN_CalculateGestationalAge](SPD.[SubjectID])) AS [GestationalAge]
			,SPD.[G]
			,SPD.[P]
			,SPD.[L]
			,SPD.[A]
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
	LEFT JOIN [dbo].[Tbl_ReligionMaster] RM WITH (NOLOCK) ON RM.[ID] = SAD.[Religion_Id]  
	LEFT JOIN [dbo].[Tbl_CasteMaster] CAM WITH (NOLOCK) ON CAM.[ID] = SAD.[Caste_Id]   
	LEFT JOIN [dbo].[Tbl_Gov_IDTypeMaster] GIM WITH (NOLOCK) ON GIM.[ID] = SPRD.[GovIdType_ID]    
	LEFT JOIN [dbo].[Tbl_CommunityMaster] COM WITH (NOLOCK) ON COM.[ID] = SAD.[Community_Id] 
	WHERE  SPRD.[CHCID]  = @CHCId AND SPRD.[RegisteredFrom] = 9 AND ISNULL(SPRD.[SpouseSubjectID],'') = '' 
	AND SPRD.[UniqueSubjectID] NOT IN (SELECT SpouseSubjectID  FROM [dbo].[Tbl_SubjectPrimaryDetail] WHERE (SPRD.[SubjectTypeID] = 2 OR SPRD.[ChildSubjectTypeID] = 2))
	AND SPRD.[ID] IN( SELECT SubjectID FROM[dbo].[Tbl_PositiveResultSubjectsDetail] WHERE UPPER(HPLCStatus) = 'P' )
	AND (CONVERT(DATE,SPRD.[DateofRegister],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103))
	 AND (SPRD.[SubjectTypeID] = 1 OR SPRD.[ChildSubjectTypeID] = 1)
	ORDER BY [GestationalAge] DESC
END