--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchLMPErrorCorrectionReport' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchLMPErrorCorrectionReport --'20-03-2021','25-06-2021', 0,0,0,0
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchLMPErrorCorrectionReport] 
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
		,CONVERT(VARCHAR,LUD.[OldLMP],103) AS OldLMPDate
		,CONVERT(VARCHAR,LUD.[NewLMP],103) AS RevisedLMPDate
		,CONVERT(VARCHAR,LUD.[CreatedOn],103) AS DateChanged
		,(UM.[FirstName] + '  ' + UM.[LastName]) AS ANMName 
		,UM.[ContactNo1] AS ANMContact
		,DM.[Districtname] AS DistrictName
		,CM.[CHCname] AS CHCName
		,PM.[PHCname] AS PHCName
		,(SELECT TOP 1 [FirstName] FROM Tbl_UserMaster WHERE DistrictID = UM.[DistrictID] AND IsActive = 1 AND [UserType_ID] = (SELECT ID FROM [dbo].[Tbl_UserTypeMaster] WHERE Usertype = 'DC') ORDER BY ID DESC) AS DCName
		,(SELECT TOP 1 [ContactNo1] FROM Tbl_UserMaster WHERE DistrictID = UM.[DistrictID] AND IsActive = 1 AND [UserType_ID] = (SELECT ID FROM [dbo].[Tbl_UserTypeMaster] WHERE Usertype = 'DC') ORDER BY ID DESC) AS DCContact
		
	FROM [dbo].[Tbl_LMPUpdationDetails] LUD  
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = LUD.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SP.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = SP.[AssignANM_ID]
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK) ON DM.[ID] = SP.[DistrictID]
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.[ID] = SP.[CHCID]
	LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK) ON PM.[ID] = SP.[PHCID]
	WHERE  (@DistrictID = 0 OR SP.[DistrictID] = @DistrictID)
	AND (@CHCID = 0 OR SP.[CHCID] = @CHCID)
	AND (@PHCID = 0 OR SP.[PHCID] = @PHCID)
	AND (@ANMID = 0 OR SP.[AssignANM_ID] = @ANMID)
	AND (LUD.[CreatedOn] BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103))
END