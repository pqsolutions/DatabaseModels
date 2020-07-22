

USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_FindLastUniqueSubjectId' AND [type] = 'FN')
BEGIN
	DROP FUNCTION [dbo].[FN_FindLastUniqueSubjectId]
END
GO
CREATE FUNCTION [dbo].[FN_FindLastUniqueSubjectId]     
(  
 @ANMId INT   
)   
RETURNS VARCHAR(250)          
AS      
BEGIN  
 
DECLARE @LastUniqueSubjectId VARCHAR(250),@LastSubjetId VARCHAR(250)
SET @LastUniqueSubjectId = (SELECT TOP 1 ISNULL(SPA.UniqueSubjectID,0)
							FROM Tbl_SubjectParentDetail SPA
							LEFT JOIN Tbl_SubjectPrimaryDetail SPR WITH (NOLOCK) ON SPR.ID = SPA.SubjectID 
							WHERE AssignANM_ID = @ANMId and SPA.UniqueSubjectID LIKE  '%/F'
							ORDER BY SPA.UniqueSubjectID DESC)
 SET @LastSubjetId = @LastUniqueSubjectId						
 IF LEN(@LastSubjetId) <= 0
 BEGIN
	SET @LastSubjetId = NULL
 END
 RETURN  @LastSubjetId  
END