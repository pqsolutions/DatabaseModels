--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectsForMolecularSpecimenTestComplete' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectsForMolecularSpecimenTestComplete
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectsForMolecularSpecimenTestComplete] 
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
		,ISNULL(MSTR.[IsDamaged],0) AS SampleDamaged
		,ISNULL(MSTR.[IsProcessed],0) AS SampleProcessed
		,MSTR.[ZygosityId]
		,MSTR.[Mutation1Id]
		,MSTR.[Mutation2Id]
		,MSTR.[Mutation3]
		,MSTR.[TestResult]
		,MSTR.[ReasonForClose]
		,CONVERT(VARCHAR,MSTR.[TestDate],103) AS TestDate
	FROM [dbo].[Tbl_MolecularSpecimenTestResult] MSTR
	LEFT JOIN [dbo].[Tbl_PNDTFoetusDetail] PF WITH (NOLOCK) ON PF.[ID] = MSTR.[PNDTFoetusId]
	LEFT JOIN [dbo].[Tbl_PNDTestNew] PT WITH (NOLOCK) ON PT.[ID] = PF.[PNDTestId]
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = PT.ANWSubjectId
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = PT.ANWSubjectId
	WHERE MSTR.[MolecularLabId] = @MolecularLabId AND MSTR.[IsComplete] = 1
END