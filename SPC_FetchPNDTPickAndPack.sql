--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchPNDTPickAndPack' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchPNDTPickAndPack 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchPNDTPickAndPack] 
(
	@PNDTLocationId INT
)
AS
BEGIN
	SELECT PN.[ANWSubjectId]
		,(SP.[FirstName] + ' ' + SP.[LastName]) AS SubjectName
		,SPD.[RCHID]
		,PFD.[SampleRefId]
		,PFD.[FoetusName]
		,PFD.[CVSSampleRefId]
		,CONVERT(VARCHAR,PN.[PNDTDateTime],103) AS [SpecimenCollectionDate]
		,PN.[ID] AS PNDTestId
		,PFD.[ID] AS PNDTFoetusId
		,PN.[PNDTLocationId] 
	FROM [dbo].[Tbl_PNDTestNew] PN
	LEFT JOIN [dbo].[Tbl_PNDTFoetusDetail] PFD WITH (NOLOCK) ON PFD.[PNDTestId] = PN.[ID]
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = PN.[ANWSubjectId]
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SP.[UniqueSubjectID]
	WHERE PN.[PNDTLocationId] = @PNDTLocationId
	AND PN.[ID] NOT IN (SELECT PNDTestId FROM [dbo].[Tbl_PNDTShipmentsDetail]) 
END
