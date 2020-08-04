USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Unsent Samples  which are not shipped of particular ANM in Notification

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchUnsentSamples' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchUnsentSamples 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchUnsentSamples] 
(
	@ANMID INT
)
AS
BEGIN
	
	BEGIN
		SELECT SC.[UniqueSubjectID]
		  ,SC.[ID] AS SampleCollectionID
		  ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
		  ,SPR.[RCHID] 
		  ,SC.[BarcodeNo]
		  ,SP.[MobileNo] AS ContactNo
		  ,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
		  ,CAST((SELECT [dbo].[FN_CalculateGestationalAge](SPR.[SubjectID])) AS DECIMAL(18,1)) AS GestationalAge
		   FROM Tbl_SampleCollection SC
		   LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.ID = SC.SubjectID
		   LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.SubjectID = SP.ID
		WHERE SC.CollectedBy = @ANMID AND SC.SampleTimeoutExpiry != 1 AND SC.SampleDamaged != 1 --AND SP.[IsActive] = 1
		AND SC.BarcodeNo NOT IN (SELECT BarcodeNo from Tbl_ANMCHCShipmentsDetail)
		ORDER BY GestationalAge DESC
	END	
END
