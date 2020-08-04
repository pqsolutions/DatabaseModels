USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Sample collection which are not generated the Shipment Id of particular ANM user /CHC

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSampleCollection' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSampleCollection
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSampleCollection] 
(
	@UserID INT
	,@CollectionFrom INT
)
AS
BEGIN
	DECLARE @CollectFrom VARCHAR(10),@CHCID INT
	SET @CollectFrom = (SELECT CommonName FROM Tbl_ConstantValues WHERE ID = @CollectionFrom AND comments='SampleCollectionFrom')
	SET @CHCID = (SELECT CHCID FROM Tbl_UserMaster WHERE ID = @UserID)
	IF @CollectFrom = 'ANM'
	BEGIN 
		SELECT SC.[UniqueSubjectID]
		  ,SC.[ID] AS SampleCollectionID
		  ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
		  ,SPR.[RCHID] 
		  ,SC.[BarcodeNo]
		  ,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
		  ,CAST((SELECT [dbo].[FN_CalculateGestationalAge](SPR.[SubjectID])) AS DECIMAL(18,1)) AS GestationalAge
		   FROM Tbl_SampleCollection SC
		   LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.ID = SC.SubjectID
		   LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.SubjectID = SP.ID
		WHERE SC.CollectedBy = @UserID AND SC.CollectionFrom = @CollectionFrom  AND SC.SampleTimeoutExpiry != 1 AND SC.SampleDamaged != 1
		--AND SP.[IsActive] = 1 
		AND SC.BarcodeNo NOT IN (SELECT BarcodeNo from Tbl_ANMCHCShipmentsDetail)
		ORDER BY GestationalAge DESC
    END
    ELSE IF @CollectFrom = 'CHC'
    BEGIN
		SELECT SC.[UniqueSubjectID]
		  ,SC.[ID] AS SampleCollectionID
		  ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
		  ,SPR.[RCHID] 
		  ,SC.[BarcodeNo]
		  ,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
		  ,CAST((SELECT [dbo].[FN_CalculateGestationalAge](SPR.[SubjectID])) AS DECIMAL(18,1)) AS GestationalAge
		   FROM Tbl_SampleCollection SC
		   LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.ID = SC.SubjectID
		   LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.SubjectID = SP.ID
		WHERE SP.CHCID = @CHCID AND SC.CollectionFrom = @CollectionFrom   AND SC.SampleTimeoutExpiry != 1 AND SC.SampleDamaged != 1
		--AND SP.[IsActive] = 1 
		AND SC.BarcodeNo NOT IN (SELECT BarcodeNo from Tbl_ANMCHCShipmentsDetail)
		ORDER BY GestationalAge DESC
    END
END
