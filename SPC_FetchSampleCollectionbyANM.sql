USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Sample collection which are not generated the Shipment Id of particular ANM

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSampleCollectionbyANM' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSampleCollectionbyANM
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSampleCollectionbyANM] (@ANMID INT)
AS
BEGIN
	SELECT SC.[SubjectID]
      ,SC.[UniqueSubjectID]
      ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
      ,SC.[BarcodeNo]
      ,(CONVERT(VARCHAR,SC.[SampleCollectionDate],105) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
       FROM Tbl_SampleCollection SC
       LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.ID = SC.SubjectID
       WHERE SC.CollectedBy = @ANMID AND SC.ID NOT IN (SELECT SampleCollectionID from Tbl_ANMShipment)
END
