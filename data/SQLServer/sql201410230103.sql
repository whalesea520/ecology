ALTER PROCEDURE HrmSubCompany_Insert
    (
      @subcompanyname_1 varchar(200) ,
      @subcompanydesc_2 varchar(200) ,
      @companyid_3 tinyint ,
      @supsubcomid_4 int ,
      @url_5 varchar(50) ,
      @showorder_6 int ,
      @flag INTEGER OUTPUT ,
      @msg VARCHAR(80) OUTPUT
    )
AS 
    DECLARE @count INT
    DECLARE @count1 INT
    SELECT  @count = COUNT(*)
    FROM    HrmSubCompany
    WHERE   subcompanyname = @subcompanyname_1 
    AND supsubcomid = @supsubcomid_4
    SELECT  @count1 = COUNT(*)
    FROM    HrmSubCompany
    WHERE   subcompanydesc = @subcompanydesc_2
    AND supsubcomid = @supsubcomid_4
    IF @count > 0 
        BEGIN
            SET @flag = 2
            SET @msg = '该分部简称已经存在，不能保存！'
            RETURN
        END
    IF @count1 > 0 
        BEGIN
            SET @flag = 3
            SET @msg = '该分部全称已经存在，不能保存！'
            RETURN
        END
    INSERT  INTO HrmSubCompany
            ( subcompanyname ,
              subcompanydesc ,
              companyid ,
              supsubcomid ,
              url ,
              showorder
            )
    VALUES  ( @subcompanyname_1 ,
              @subcompanydesc_2 ,
              @companyid_3 ,
              @supsubcomid_4 ,
              @url_5 ,
              @showorder_6 
            )
    SELECT  ( MAX(id) )
    FROM    HrmSubCompany
    IF @@error <> 0 
        BEGIN
            SET @flag = 1
            SET @msg = '	更新储存过程失败'
            RETURN
        END
    ELSE 
        BEGIN
            SET @flag = 0
            SET @msg = '	更新储存过程成功'
            RETURN
        END
GO
ALTER PROCEDURE HrmSubCompany_Update
    (
      @id_1 int ,
      @subcompanyname_2 varchar(200) ,
      @subcompanydesc_3 varchar(200) ,
      @companyid_4 tinyint ,
      @supsubcomid_5 int ,
      @url_6 varchar(50) ,
      @showorder_7 int ,
      @flag INTEGER OUTPUT ,
      @msg VARCHAR(80) OUTPUT
    )
AS 
    DECLARE @count INT
    DECLARE @count1 INT
    SELECT  @count = COUNT(*)
    FROM    HrmSubCompany
    WHERE   subcompanyname = @subcompanyname_2
            AND id != @id_1
            AND supsubcomid = @supsubcomid_5
    SELECT  @count1 = COUNT(*)
    FROM    HrmSubCompany
    WHERE   subcompanydesc = @subcompanydesc_3
            AND id != @id_1
            AND supsubcomid = @supsubcomid_5
    IF @count > 0 
        BEGIN
            SET @flag = 2
            SET @msg = '该分部简称已经存在，不能保存！'
            RETURN
        END
    IF @count1 > 0 
        BEGIN
            SET @flag = 3
            SET @msg = '该分部全称已经存在，不能保存！'
            RETURN
        END
    UPDATE  HrmSubCompany
    SET     subcompanyname = @subcompanyname_2 ,
            subcompanydesc = @subcompanydesc_3 ,
            companyid = @companyid_4 ,
            supsubcomid = @supsubcomid_5 ,
            url = @url_6 ,
            showorder = @showorder_7
    WHERE   ( id = @id_1 )
    IF @@error <> 0 
        BEGIN
            SET @flag = 1
            SET @msg = '	更新储存过程失败'
            RETURN
        END
    ELSE 
        BEGIN
            SET @flag = 0
            SET @msg = '	更新储存过程成功'
            RETURN
        END
GO
