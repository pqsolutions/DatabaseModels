--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMolecularLabBloodTestReports' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMolecularLabBloodTestReports --1 , '08/10/2020',  '08/06/2021',0,0
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMolecularLabBloodTestReports] 
(
	@MolecularLabId INT
	,@FromDate VARCHAR(250)
	,@ToDate VARCHAR(250)
	,@DistrictID INT
	,@CHCID INT
)
AS
BEGIN
	SELECT SP.[ID] AS SubjectId
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName] ) AS SubjectName
		,MSTR.[UniqueSubjectID]
		,ST.[SubjectType] 
		,ISNULL(SPR.[RCHID] ,'N/A') AS RCHID
		,SP.[Age] 
		,SP.[Gender] 
		,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN 'N/A' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB
		,SP.[MobileNo] AS ContactNo 
		,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE 'N/A' END AS LMPDate

		,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
		--(SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge
		(SELECT [dbo].[FN_CalculateGAatRegDate](SP.[ID] , SP.[DateofRegister])) ELSE 'N/A' END AS GestationalAge
		,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
		 ('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
		 CONVERT(VARCHAR,SPR.[A])) ELSE 'N/A' END AS ObstetricScore
		,ISNULL(SPR.[ECNumber],'N/A') AS ECNumber
		,CONVERT(VARCHAR,SP.[DateofRegister],103) AS RegistrationDate
		,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) AS SampleCollectionDate
		,(SAD.Address1 + ' ' + SAD.[Address2] + ' ' + SAD.[Address3] + ' - ' + SAD.[Pincode]) AS Address
		,MSTR.[BarcodeNo]
		,SCS.[BarcodeNo] AS SpouseBarcodeNo
		,DM.[Districtname]
		,CM.[CHCname]
		,BM.[Blockname]
		,PM.[PHCname]
		,SM.[SCname]
		,RI.[RIsite]
		,ANM.[FirstName] AS ANMName
		
		,MSTR.[TestResult] MolecularLabBloodResult
		,MSTR.[ReasonForClose]
		,CONVERT(VARCHAR,MSTR.[TestDate],103) AS TestDate
		,MLU.[FirstName] AS LabInchargeName
		,MLI.[Designation] AS LabIchargeDesignation
		,MLI.[Department] AS LabIchargeDepartment
		,MLI.[Incharge] AS Incharge 
		,MLI.[MolAddress] AS LabInchargeAddress
		,PRSDS.[UniqueSubjectID] AS SpouseSubjectId
		,(SPDS.[FirstName] + ' ' + SPDS.[LastName]) AS SpouseName

		,CASE WHEN MSTRS.[IsComplete] = 1 THEN MSTRS.[TestResult] ELSE 'N/A' END AS SpouseMolecularLabBloodResult
		,MLM.[MLabName] AS MolecularLabName
		,OP.[OrderPhysician] AS OrderingPhysician
		,(LT.[FirstName] + ' ' + LT.[LastName] )AS LabTechnician
		
	FROM [dbo].[Tbl_MolecularBloodTestResult] MSTR
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.[UniqueSubjectID] = MSTR.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SPDS WITH (NOLOCK) ON SPDS.[UniqueSubjectID] = SP.[SpouseSubjectID]
	LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SP.[SpouseSubjectID]
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.[UniqueSubjectID] = MSTR.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[ChildSubjectTypeID] 
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[BarcodeNo] = MSTR.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_SampleCollection] SCS WITH (NOLOCK) ON SCS.[UniqueSubjectID] = SPDS.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.[ID]= SP.[DistrictID]
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK)ON  CM.[ID]= SP.[CHCID]
	LEFT JOIN [dbo].[Tbl_BlockMaster] BM WITH (NOLOCK)ON  BM.[ID]= CM.[BlockID]
	LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK)ON  PM.[ID]= SP.[PHCID]
	LEFT JOIN [dbo].[Tbl_SCMaster] SM WITH (NOLOCK)ON  sM.[ID]= SP.[SCID]
	LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK)ON  RI.[ID]= SP.[RIID]
	LEFT JOIN [dbo].[Tbl_UserMaster] ANM WITH (NOLOCK)ON  ANM.[ID]= SP.[AssignANM_ID]
	LEFT JOIN [dbo].[Tbl_UserMaster] MLU  WITH (NOLOCK)ON  MLU.[ID]= MSTR.[UpdatedBy]
	LEFT JOIN [dbo].[Tbl_PositiveResultSubjectsDetail] PRSD WITH (NOLOCK) ON PRSD.[BarcodeNo] = MSTR.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_PositiveResultSubjectsDetail] PRSDS WITH (NOLOCK) ON SPDS.[UniqueSubjectID] = PRSDS.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_MolecularLabMaster] MLM WITH (NOLOCK) ON MLM.[ID] = MSTR.[MolecularLabId]
	LEFT JOIN [dbo].[Tbl_MolecularBloodTestResult] MSTRS WITH (NOLOCK) ON MSTRS.[UniqueSubjectID] =  SP.[SpouseSubjectID]
	LEFT JOIN [dbo].[Tbl_MolecularLabOrderPhysicianDetails] OP WITH (NOLOCK) ON MSTR.[MolecularLabId] = OP.[MolecularLabId]
	LEFT JOIN [dbo].[Tbl_CentralLabShipmentsDetail] CSD WITH (NOLOCK) ON MSTR.[BarcodeNo] = CSD.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_CentralLabShipments] CS WITH (NOLOCK) ON CS.[ID] = CSD.[ShipmentID] AND CS.[ReceivedDate] IS NOT NULL
	LEFT JOIN [dbo].[Tbl_UserMaster] LT  WITH (NOLOCK)ON  LT.[ID]= CS.[UpdatedBy]
	LEFT JOIN [dbo].[Tbl_MolecularLabInchargeDetails] MLI  WITH (NOLOCK)ON  MLI.[UserId]= MLU.[ID]
	WHERE MSTR.[MolecularLabId] = @MolecularLabId AND MSTR.[IsComplete] = 1
	AND  PRSD.[HPLCStatus] = 'P' AND PRSD.[IsActive] = 1 AND PRSDS.[HPLCStatus] = 'P' AND PRSDS.[IsActive] = 1 
	AND (@CHCID = 0 OR SP.[CHCID] = @CHCID)
	AND (@DistrictID = 0 OR SP.[DistrictID] = @DistrictID)
	AND (MSTR.[TestDate] BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103))
	ORDER BY MSTR.[TestDate] DESC
END