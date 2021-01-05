ALTER PROCEDURE hrmpubholiday_copy(
                @fromyear  VARCHAR(4),
                @toyear    VARCHAR(4),
                @countryid VARCHAR(4),
                @flag      INTEGER OUTPUT,
                @msg       VARCHAR(80) OUTPUT)
AS
  DELETE FROM hrmpubholiday
  WHERE       Substring(holidaydate,1,4) = @toyear
              AND countryid = @countryid
  DECLARE
    @all_cursor  CURSOR,
    @tempdate   VARCHAR(10),
    @tempname   VARCHAR(255),
    @temptype   VARCHAR(1)
  SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR SELECT Substring(holidaydate,5,6),
                                                          holidayname ,
                                                          changetype
                                                   FROM   hrmpubholiday
                                                   WHERE  Substring(holidaydate,1,4) = @fromyear
                                                          AND countryid = @countryid
  OPEN @all_cursor
  FETCH NEXT FROM @all_cursor
  INTO @tempdate,@tempname,@temptype
  WHILE @@FETCH_STATUS = 0
    BEGIN
      INSERT INTO hrmpubholiday(countryid,
                                holidaydate,
                                holidayname,
                                changetype)
      VALUES     (@countryid,
                  @toyear + @tempdate,
                  @tempname,
                  @temptype)
      FETCH NEXT FROM @all_cursor
      INTO @tempdate,@tempname,@temptype
    END
  CLOSE @all_cursor
  DEALLOCATE @all_cursor
  IF @@ERROR <> 0
    BEGIN
      SET @flag = 1
      SET @msg = '插入失败'
    END
   ELSE
    BEGIN
      SET @flag = 0
      SET @msg = '操作成功'
    END

GO
