--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSSTResultCorrectionReport' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSSTResultCorrectionReport --'20-03-2021','25-06-2021', 0,0,0,0
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSSTResultCorrectionReport] 
(
	@FromDate VARCHAR(250)
	,@ToDate VARCHAR(250)
	,@DistrictID INT
	,@CHCID INT
	,@PHCID INT
	,@ANMID INT
)
AS
BEGIN
	SELECT  (SP.[FirstName] +' '+ SP.[LastName]) AS SubjectName
		,SP.[UniqueSubjectID] AS SubjectID
		,SUD.[Barcode]
		,SUD.[OldResult] OldSSTResult
		,SUD.[NewResult] RevisedSSTResult
		,CONVERT(VARCHAR,SUD.[CreatedOn],103) AS DateChanged
		,(UM.[FirstName] + '  ' + UM.[LastName]) AS ANMName 
		,UM.[ContactNo1] AS ANMContact
		,DM.[Districtname] AS DistrictName
		,CM.[CHCname] AS CHCName
		,PM.[PHCname] AS PHCName
		,(SELECT TOP 1 [FirstName] FROM Tbl_UserMaster WHERE DistrictID = UM.[DistrictID] AND IsActive = 1 AND [UserType_ID] = (SELECT ID FROM [dbo].[Tbl_UserTypeMaster] WHERE Usertype = 'DC') ORDER BY ID DESC) AS DCName
		,(SELECT TOP 1 [ContactNo1] FROM Tbl_UserMaster WHERE DistrictID = UM.[DistrictID] AND IsActive = 1 AND [UserType_ID] = (SELECT ID FROM [dbo].[Tbl_UserTypeMaster] WHERE Usertype = 'DC') ORDER BY ID DESC) AS DCContact
		
	FROM [dbo].[Tbl_SSTUpdationDetails] SUD  
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = SUD.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SP.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = SP.[AssignANM_ID]
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK) ON DM.[ID] = SP.[DistrictID]
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.[ID] = SP.[CHCID]
	LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK) ON PM.[ID] = SP.[PHCID]
	WHERE  (@DistrictID = 0 OR SP.[DistrictID] = @DistrictID)
	AND (@CHCID = 0 OR SP.[CHCID] = @CHCID)
	AND (@PHCID = 0 OR SP.[PHCID] = @PHCID)
	AND (@ANMID = 0 OR SP.[AssignANM_ID] = @ANMID)
	AND (SUD.[CreatedOn] BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103))
END