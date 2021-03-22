--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchUpdateBarcodeDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchUpdateBarcodeDetail
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchUpdateBarcodeDetail] 
(
	@ID VARCHAR(100)
)
AS
DECLARE
	@Indexvar INT  
	,@TotalCount INT  
	,@CurrentIndex NVARCHAR(200)
	
BEGIN
	
	CREATE TABLE #TempTable(UniqueSubjectId VARCHAR(250), SubjectName VARCHAR(250), ANMName VARCHAR(MAX), ANMMobile VARCHAR(150),ANMEmail VARCHAR(500), DCName VARCHAR(MAX), DCMobile VARCHAR(150), 
	OldBarcode VARCHAR(200), NewBarcode VARCHAR(200),SCName VARCHAR(250),SCMobileNo VARCHAR(250),DCEmail VARCHAR(500), SCEmail VARCHAR(500))

	CREATE  TABLE #TempTable1(TempCol NVARCHAR(250), ArrayIndex INT)
	INSERT INTO #TempTable1(TempCol,ArrayIndex) (SELECT Value,id FROM dbo.FN_Split(@ID,','))

	SET @IndexVar = 0  
	SELECT @TotalCount = COUNT(*) FROM #TempTable1  
	WHILE @Indexvar < @TotalCount  
	BEGIN
		SELECT @IndexVar = @IndexVar + 1
		SELECT @CurrentIndex = TempCol FROM #TempTable1 WHERE ArrayIndex = @Indexvar

		INSERT INTO #TempTable(UniqueSubjectId, SubjectName, ANMName, ANMMobile, ANMEmail, DCName, DCMobile, OldBarcode, NewBarcode,SCName,SCMobileNo,DCEmail,SCEmail)
		SELECT BU.[UniqueSubjectId]
			,SP.[FirstName]
			,(UM.[User_gov_code] +'-'+ UM.[FirstName]) AS ANMName
			,UM.[ContactNo1]
			,UM.[Email]
			,(SELECT TOP 1 [FirstName] FROM Tbl_UserMaster WHERE DistrictID = UM.[DistrictID] AND IsActive = 1 AND [UserType_ID] = (SELECT ID FROM [dbo].[Tbl_UserTypeMaster] WHERE Usertype = 'DC') ORDER BY ID DESC) AS DCName
			,(SELECT TOP 1 [ContactNo1] FROM Tbl_UserMaster WHERE DistrictID = UM.[DistrictID] AND IsActive = 1 AND [UserType_ID] = (SELECT ID FROM [dbo].[Tbl_UserTypeMaster] WHERE Usertype = 'DC') ORDER BY ID DESC) AS DCMobile
			,BU.[ExistBarcodeNo]
			,BU.[NewBarcodeNo]
			,(SELECT TOP 1 [FirstName] FROM [dbo].[Tbl_UserMaster] WHERE [UserRole_ID] = (SELECT ID FROM [dbo].[Tbl_UserRoleMaster] WHERE Userrolename = 'SPC') AND [IsActive] = 1 ORDER BY ID DESC) AS SCName
			,(SELECT TOP 1 [ContactNo1] FROM [dbo].[Tbl_UserMaster] WHERE [UserRole_ID] = (SELECT ID FROM [dbo].[Tbl_UserRoleMaster] WHERE Userrolename = 'SPC') AND [IsActive] = 1 ORDER BY ID DESC) AS SCMobileNo
			,(SELECT TOP 1 [Email] FROM Tbl_UserMaster WHERE DistrictID = UM.[DistrictID] AND IsActive = 1 AND [UserType_ID] = (SELECT ID FROM [dbo].[Tbl_UserTypeMaster] WHERE Usertype = 'DC') ORDER BY ID DESC) AS DCEmail
			,(SELECT TOP 1 [Email] FROM [dbo].[Tbl_UserMaster] WHERE [UserRole_ID] = (SELECT ID FROM [dbo].[Tbl_UserRoleMaster] WHERE Userrolename = 'SPC') AND [IsActive] = 1 ORDER BY ID DESC) AS SCEmail
		
		FROM Tbl_BarcodeUpdationDetails BU
		LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = BU.[UniqueSubjectID] 
		LEFT JOIN Tbl_UserMaster UM WITH (NOLOCK) ON UM.[ID] = SP.[AssignANM_ID] 
		WHERE BU.ID = @CurrentIndex
	END
	SELECT * FROM #TempTable

	DROP Table #TempTable1
	DROP Table #TempTable

END