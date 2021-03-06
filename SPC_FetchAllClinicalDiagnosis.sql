USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllClinicalDiagnosis' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllClinicalDiagnosis
End
GO
CREATE Procedure [dbo].[SPC_FetchAllClinicalDiagnosis]
As
Begin
	SELECT [ID]
		 ,[DiagnosisName]
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_ClinicalDiagnosisMaster]
	Order by [ID]
End
