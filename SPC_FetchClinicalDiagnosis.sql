USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchClinicalDiagnosis' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchClinicalDiagnosis
End
GO
CREATE PROCEDURE [dbo].[SPC_FetchClinicalDiagnosis](@ID INT)
As
BEGIN
	SELECT [ID]
		 ,[DiagnosisName]
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_ClinicalDiagnosisMaster] WHERE ID = @ID		
END

