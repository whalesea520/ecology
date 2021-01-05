DROP FUNCTION convToMultiLang 
GO

CREATE FUNCTION dbo.convToMultiLang(@multilang  VARCHAR(4000),@languageId INT)
RETURNS NVARCHAR(4000)
AS
  BEGIN
    DECLARE
      @dbk      VARCHAR(4000),
      @rst      VARCHAR(4000),
      @realdata VARCHAR(2000),
      @cndata   VARCHAR(2000),
      @data1    VARCHAR(2000),
      @data2    VARCHAR(2000),
      @data3    VARCHAR(2000),
      @data4    VARCHAR(2000),
      @data5    VARCHAR(2000)
    SET @dbk = @multilang;
    WHILE (charindex('~`~`',@dbk) > 0)
      BEGIN
        SET @data1 = Substring(@dbk,0,Charindex('~`~`',@dbk));
        SET @data2 = Substring(@dbk,Charindex('~`~`',@dbk) + 4,Charindex('`~`~',@dbk) - Charindex('~`~`',@dbk) - 1);
        WHILE (charindex('`~`',@data2) > 0)
          BEGIN
            SET @data3 = Substring(@data2,0,Charindex('`~`',@data2));
            SET @data4 = Substring(@data3,0,3);
            IF (len(@data3) > 2)
              BEGIN
                SET @data5 = Substring(@data3,3,Len(@data3) - 2);
              END
             ELSE
              BEGIN
                SET @data5 = '';
              END
            IF (CONVERT(INT,@data4) = 7)
              BEGIN
                SET @cndata = @data5;
              END
            IF (CONVERT(INT,@data4) = @languageId)
              BEGIN
                SET @realdata = @data5;
                BREAK;
              END
             ELSE
              BEGIN
                SET @data2 = Substring(@data2,Charindex('`~`',@data2) + 3,Len(@data2) - Charindex('`~`',@data2) - 2);
              END
          END
        IF (@realdata IS NULL OR len(@realdata) = 0)
          BEGIN
            SET @realdata = @cndata;
          END
        SET @rst = Isnull(@rst,'') + Isnull(@data1,'') + Isnull(@realdata,'');
        IF (len(@dbk) - charindex('`~`~',@dbk) - 4 > 0)
          BEGIN
            SET @dbk = Substring(@dbk,Charindex('`~`~',@dbk) + 4,Len(@dbk) - Charindex('`~`~',@dbk) - 3);
          END
         ELSE
          BEGIN
            SET @dbk = '';
          END
      END
    SET @rst = Isnull(@rst,'') + Isnull(@dbk,'');
    RETURN @rst;
  END;
GO


DROP FUNCTION convToCN 
GO

CREATE FUNCTION dbo.convToCN(@multilang  VARCHAR(4000))
RETURNS NVARCHAR(4000)
AS
  BEGIN
    RETURN dbo.convToMultiLang(@multilang,7);
  END;
GO

