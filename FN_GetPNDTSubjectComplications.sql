
USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_GetPNDTSubjectComplications' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_GetPNDTSubjectComplications
END
GO
CREATE FUNCTION [dbo].[FN_GetPNDTSubjectComplications]   
(
	@PNDTTestID INT	
) 
RETURNS VARCHAR(MAX)        
AS    
BEGIN
	DECLARE
		@Indexvar INT
		,@TotalCount INT
		,@CurrentIndex NVARCHAR(200)
		,@ComplecationsId VARCHAR(100)
		,@ComplicationsName VARCHAR(MAX)
		,@Complications VARCHAR(MAX) = ''
		,@PNDTComplecations VARCHAR(MAX)
		,@Others NVARCHAR(MAX)
		
		SELECT @ComplecationsId = PNDTComplecationsId, @Others = OthersComplecations  FROM Tbl_PNDTestNew WHERE ID = ISNULL(@PNDTTestID,0)
		SET @IndexVar = 0 
		SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](ISNULL(@ComplecationsId,0),',')
		WHILE @Indexvar < @TotalCount  
		BEGIN
			SELECT @IndexVar = @IndexVar + 1
			SELECT @CurrentIndex = Value FROM  [dbo].[FN_Split](ISNULL(@ComplecationsId,0),',') WHERE id = @Indexvar
			SELECT @ComplicationsName = ComplecationsName FROM Tbl_PNDTComplicationsMaster WHERE ID = CAST(@CurrentIndex AS INT)
			IF @ComplicationsName = 'Any other complication/s of invasive procedure'
			BEGIN
				SET @Complications = @Complications + @ComplicationsName + ' ('+ @Others + ')) '
			END
			ELSE
			BEGIN
				SET @Complications = @Complications + @ComplicationsName + ', '
			END
		END
		SET @PNDTComplecations = (SELECT LEFT(@Complications,LEN(@Complications)-1))
		
	RETURN 	@PNDTComplecations
END