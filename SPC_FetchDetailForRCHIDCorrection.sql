--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchDetailForRCHIDCorrection' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchDetailForRCHIDCorrection
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchDetailForRCHIDCorrection] 
(
	@Input VARCHAR(MAX)
)

AS
BEGIN
	SELECT  (SP.[FirstName] +' '+ SP.[LastName] ) AS SubjectName
		,SPD.[RCHID]
		,CONVERT(VARCHAR,SPD.[LMP_Date],103) AS LMPDate
		,SP.[UniqueSubjectID] AS SubjectID
		,SC.[BarcodeNo] AS BarcodeNo
		,(UM.[User_gov_code]+ ' - ' + UM.[FirstName]) AS ANMName 
		,UM.[User_gov_code] AS ANMCode
		,UM.[ContactNo1] AS ANMContact
		,CM.[CHCname] AS CHCName
		,(SELECT TOP 1 [FirstName] FROM Tbl_UserMaster WHERE DistrictID = UM.[DistrictID] AND IsActive = 1 AND [UserType_ID] = (SELECT ID FROM [dbo].[Tbl_UserTypeMaster] WHERE Usertype = 'DC') ORDER BY ID DESC) AS DCName
		,(SELECT TOP 1 [ContactNo1] FROM Tbl_UserMaster WHERE DistrictID = UM.[DistrictID] AND IsActive = 1 AND [UserType_ID] = (SELECT ID FROM [dbo].[Tbl_UserTypeMaster] WHERE Usertype = 'DC') ORDER BY ID DESC) AS DCContact
		,CASE WHEN AL.[LoginStatus] = 1 THEN 'Logged In' ELSE 'Logged Off' END AS LoginStatus
		,CASE WHEN AL.[LoginStatus] = 1 THEN 0 ELSE 1 END AS LoginIconEnableStatus

	FROM [dbo].[Tbl_SubjectPrimaryDetail] SP  
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SP.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[UniqueSubjectID] = SP.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = SP.[AssignANM_ID]
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.[ID] = SP.[CHCID]
	LEFT JOIN [dbo].[Tbl_ANMLogin] AL WITH (NOLOCK) ON AL.[ANMId] = UM.[ID]
	WHERE (SPD.[RCHID] LIKE ('%' +@Input+ '%') OR SP.[UniqueSubjectID] LIKE ('%' +@Input+ '%'))
	--(SC.[BarcodeNo] LIKE ('%' +@Input+ '%') OR  SPD.[RCHID] LIKE ('%' +@Input+ '%') OR SP.[UniqueSubjectID] LIKE ('%' +@Input+ '%') OR SP.[MobileNo] LIKE ('%' +@Input+ '%'))
	AND SP.[ChildSubjectTypeID] = 1
END