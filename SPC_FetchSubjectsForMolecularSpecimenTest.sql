--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectsForMolecularSpecimenTest' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectsForMolecularSpecimenTest
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectsForMolecularSpecimenTest] 
(
	@MolecularLabId INT
)
AS
BEGIN
	SELECT SP.[ID] AS SubjectId
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		,SP.[UniqueSubjectID]
		,ISNULL(SPR.[RCHID] ,'') AS RCHID
		,PF.[FoetusName]
		,PF.[CVSSampleRefId]
		,PF.[SampleRefId]
		,PF.[ID] AS PNDTFoetusId
		,PF.[PNDTestId]
	,ISNULL(SD.[SampleDamaged],0) AS SampleDamaged
	FROM [dbo].[Tbl_PNDTShipments] S 
	LEFT JOIN [dbo].[Tbl_PNDTShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
	LEFT JOIN [dbo].[Tbl_PNDTestNew] PT WITH (NOLOCK) ON PT.ID = SD.PNDTestId
	LEFT JOIN [dbo].[Tbl_PNDTFoetusDetail] PF WITH (NOLOCK) ON PF.[ID] = SD.[PNDTFoetusId] AND PF.[PNDTestId] = PT.[ID]
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = PT.ANWSubjectId
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = PT.ANWSubjectId
	WHERE S.[ReceivedDateTime] IS NOT NULL AND S.[ReceivingMolecularLabId] = @MolecularLabId 
	AND SD.[PNDTFoetusId]   NOT IN (SELECT PNDTFoetusId FROM Tbl_MolecularSpecimenTestResult)
	
END