USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_Split' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_Split
END
GO
CREATE FUNCTION [dbo].[FN_Split] (@list nvarchar(4000),@Del char(1))
   RETURNS @tbl TABLE (id int identity(1,1) ,Value varchar(50) NOT NULL) AS
BEGIN
   DECLARE @pos        int,
           @nextpos    int,
           @valuelen   int

   SELECT @pos = 0, @nextpos = 1

   WHILE @nextpos > 0
   BEGIN
      SELECT @nextpos = charindex(@Del, @list, @pos + 1)
      SELECT @valuelen = CASE WHEN @nextpos > 0
                              THEN @nextpos
                              ELSE len(@list) + 1
                         END - @pos - 1
      INSERT @tbl (value)
         VALUES (convert(varchar, case when substring(@list, @pos + 1, @valuelen)='' then '0' else substring(@list, @pos + 1, @valuelen) end))
      SELECT @pos = @nextpos
   END
  RETURN
END