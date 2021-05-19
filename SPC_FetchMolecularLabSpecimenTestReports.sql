--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMolecularLabSpecimenTestReports' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMolecularLabSpecimenTestReports
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMolecularLabSpecimenTestReports] 
(
	@MolecularLabId INT
)
AS
BEGIN
	SELECT SP.[ID] AS SubjectId
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		,SP.[UniqueSubjectID]
		,ISNULL(SPR.[RCHID] ,'') AS RCHID
		,ST.[SubjectType] 
		,SP.[Age] 
		,SP.[Gender] 
		,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB
		,SP.[MobileNo] AS ContactNo 
		,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate

		,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
		--(SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge
		(SELECT [dbo].[FN_CalculateGAatRegDate](SP.[ID] , SP.[DateofRegister])) ELSE '' END AS GestationalAge
		,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
		 ('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
		 CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore
		,ISNULL(SPR.[ECNumber],'') AS ECNumber
		,CONVERT(VARCHAR,SP.[DateofRegister],103) AS RegistrationDate
		,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) AS SampleCollectionDate
		,(SAD.Address1 + ' ' + SAD.[Address2] + ' ' + SAD.[Address3] + ' - ' + SAD.[Pincode]) AS Address
		,SC.[BarcodeNo]

		,SPDS.[UniqueSubjectID] AS SpouseSubectId
		,(SPDS.[FirstName] + ' ' +SPDS.[LastName] ) AS SpouseName

		,DM.[Districtname]
		,CM.[CHCname]
		,BM.[Blockname]
		,PM.[PHCname]
		,SM.[SCname]
		,RI.[RIsite]
		,ANM.[FirstName] AS ANMName

		,PF.[FoetusName]
		,PF.[CVSSampleRefId]
		,PF.[SampleRefId]
		,PF.[ID] AS PNDTFoetusId
		,PF.[PNDTestId]
		,ISNULL(MSTR.[IsDamaged],0) AS SampleDamaged
		,ISNULL(MSTR.[IsProcessed],0) AS SampleProcessed
		,CASE WHEN MSTR.[IsComplete] = 1 THEN MSTR.[TestResult] ELSE '' END AS SpecimenTestResult
		,MSTR.[ReasonForClose]
		,CONVERT(VARCHAR,MSTR.[TestDate],103) AS MolecularSpecimenTestDate

		,CASE WHEN MS.[IsComplete] = 1 THEN MS.[TestResult] ELSE '' END AS MolecularLabBloodResult
		,CASE WHEN MSS.[IsComplete] = 1 THEN MSS.[TestResult] ELSE '' END AS SpouseMolecularLabBloodResult

		,MLM.[MLabName] AS MolecularLabName
		,'' AS OrderingPhysician

	FROM [dbo].[Tbl_MolecularSpecimenTestResult] MSTR
	LEFT JOIN [dbo].[Tbl_PNDTFoetusDetail] PF WITH (NOLOCK) ON PF.[ID] = MSTR.[PNDTFoetusId]
	LEFT JOIN [dbo].[Tbl_PNDTestNew] PT WITH (NOLOCK) ON PT.[ID] = PF.[PNDTestId]
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = PT.[ANWSubjectId]
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SPDS WITH (NOLOCK) ON SPDS.[UniqueSubjectID] = SP.[SpouseSubjectID]
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR WITH (NOLOCK) ON SPR.[UniqueSubjectID] = PT.[ANWSubjectId]
	LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = PT.[ANWSubjectId]
	LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[ChildSubjectTypeID]
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.[ID] = SP.[DistrictID]
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK)ON  CM.[ID] = SP.[CHCID]
	LEFT JOIN [dbo].[Tbl_BlockMaster] BM WITH (NOLOCK)ON  BM.[ID] = CM.[BlockID]
	LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK)ON  PM.[ID] = SP.[PHCID]
	LEFT JOIN [dbo].[Tbl_SCMaster] SM WITH (NOLOCK)ON  sM.[ID] = SP.[SCID]
	LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON  RI.[ID] = SP.[RIID]
	LEFT JOIN [dbo].[Tbl_UserMaster] ANM WITH (NOLOCK)ON  ANM.[ID] = SP.[AssignANM_ID]
	LEFT JOIN [dbo].[Tbl_UserMaster] MLU  WITH (NOLOCK)ON  MLU.[ID] = MSTR.[UpdatedBy]
	LEFT JOIN [dbo].[Tbl_MolecularBloodTestResult] MS WITH (NOLOCK) ON MS.[UniqueSubjectID] = MSTR.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[UniqueSubjectID] = SP.[UniqueSubjectID] AND SC.[SampleDamaged] = 0 AND SC.[SampleTimeoutExpiry] = 0
	LEFT JOIN [dbo].[Tbl_MolecularBloodTestResult] MSS WITH (NOLOCK) ON MSS.[UniqueSubjectID] =  SP.[SpouseSubjectID]
	LEFT JOIN [dbo].[Tbl_MolecularLabMaster] MLM WITH (NOLOCK) ON MLM.[ID] = MSTR.[MolecularLabId]

	WHERE MSTR.[MolecularLabId] = @MolecularLabId AND PF.[IsTestComplete] = 1 AND MSTR.[IsComplete] = 1

	ORDER BY PF.Resultupdatedon DESC
END