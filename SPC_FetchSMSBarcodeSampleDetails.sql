--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSMSBarcodeSampleDetails' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSMSBarcodeSampleDetails
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSMSBarcodeSampleDetails] 
(
	@Barcode VARCHAR(200)
	,@SubjectId VARCHAR(250))
AS
BEGIN
	SELECT  SC.[BarcodeNo] 
			,SC.[UniqueSubjectID]
			,SP.[FirstName] AS SubjectName
			,SP.[MobileNo] AS SubjectMobilNo
			,(UM.[FirstName] + ' ' +UM.[LastName]) AS ANMName
			,UM.[ContactNo1] AS ANMMobileNo
	FROM [dbo].[Tbl_SampleCollection] SC
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP ON SP.[UniqueSubjectID] = SC.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_UserMaster] UM ON UM.[ID] = SP.[AssignANM_ID]
	WHERE SC.[BarcodeNo]  = @Barcode 
	AND SC.[UniqueSubjectID] = @SubjectId
	ORDER BY SC.ID DESC
END

