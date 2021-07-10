--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSampleDetailsForSMSbyBarcode' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSampleDetailsForSMSbyBarcode
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSampleDetailsForSMSbyBarcode] 
(
	@Barcode VARCHAR(200)
)
AS
BEGIN
	SELECT  SC.[BarcodeNo] 
			,SC.[UniqueSubjectID]
			,SP.[SubjectTypeID]
			,SP.[FirstName] AS SubjectName
			,SP.[MobileNo] AS SubjectMobilNo
			,(UM.[FirstName] + ' ' +UM.[LastName]) AS ANMName
			,UM.[ContactNo1] AS ANMMobileNo
	FROM [dbo].[Tbl_SampleCollection] SC
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = SC.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON SP.[SubjectTypeID] = ST.[ID]
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON  UM.[ID] = SP.[AssignANM_ID]
	WHERE SC.[BarcodeNo]  = @Barcode 
	ORDER BY SC.ID DESC
END
