IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSCDCDetails' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSCDCDetails
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSCDCDetails] 
(
	@ANMId INT 
	,@ExistANMId INT
)
AS
DECLARE @DistrictId INT
		,@ExistDistrictId INT
		,@DCName VARCHAR(250)
		,@DCContactNo VARCHAR(250)
		,@DCEmail VARCHAR(MAX)
		,@ExistDCName VARCHAR(250)
		,@ExistDCContactNo VARCHAR(250)
		,@ExistDCEmail VARCHAR(MAX)
		,@SCName VARCHAR(250)
		,@SCContactNo VARCHAR(250)
		,@SCEmail VARCHAR(MAX)
BEGIN
	SET @DistrictId = (SELECT DistrictID  FROM [dbo].[Tbl_UserMaster] WHERE ID = @ANMId)
	SET @ExistDistrictId = (SELECT DistrictID  FROM [dbo].[Tbl_UserMaster] WHERE ID = @ExistANMId)

	SELECT TOP 1 
		@DCName= [FirstName] 
		,@DCContactNo =[ContactNo1] 
		,@DCEmail= [Email]
	FROM [dbo].[Tbl_UserMaster] 
	WHERE [UserType_ID] = (SELECT ID FROM [dbo].[Tbl_UserTypeMaster] WHERE Usertype = 'DC') AND [IsActive] = 1 AND DistrictId = @DistrictId ORDER BY ID DESC

	SELECT TOP 1 
		@ExistDCName= [FirstName] 
		,@ExistDCContactNo =[ContactNo1] 
		,@ExistDCEmail= [Email]
	FROM [dbo].[Tbl_UserMaster] 
	WHERE [UserType_ID] = (SELECT ID FROM [dbo].[Tbl_UserTypeMaster] WHERE Usertype = 'DC') AND [IsActive] = 1 AND DistrictId = @ExistDistrictId ORDER BY ID DESC

	SELECT TOP 1 
		@SCName= [FirstName] 
		,@SCContactNo =[ContactNo1] 
		,@SCEmail= [Email]
	FROM [dbo].[Tbl_UserMaster] 
	WHERE [UserRole_ID] = (SELECT ID FROM [dbo].[Tbl_UserRoleMaster] WHERE Userrolename = 'SPC') AND [IsActive] = 1 ORDER BY ID DESC

	SELECT @DCName AS DCName
		,@DCContactNo AS DCContactNo
		,@DCEmail AS DCEmail
		,@ExistDCName AS ExistDCName
		,@ExistDCContactNo AS ExistDCContactNo
		,@ExistDCEmail AS ExistDCEmail
		,@SCName AS SCName
		,@SCContactNo AS SCContactNo
		,@SCEmail AS SCEmail

END