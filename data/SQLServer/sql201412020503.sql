CREATE TABLE hrmcitytwo
    (
      id INT NOT NULL ,
      cityname VARCHAR(60) NULL ,
      citylongitude DECIMAL(8, 3) NULL ,
      citylatitude DECIMAL(8, 3) NULL ,
      cityid INT NULL
    )
GO
CREATE PROCEDURE HrmCityTwo_Insert
    (
      @cityname VARCHAR(60) ,
      @citylongitude DECIMAL(8, 3) ,
      @citylatitude DECIMAL(8, 3) ,
      @citypid INT ,
      @flag INTEGER OUTPUT ,
      @msg VARCHAR(80) OUTPUT 
    )
AS 
    DECLARE @cityid INT
    SELECT  @cityid = ( MAX(id) + 1 )
    FROM    HrmCityTwo 
    IF @cityid IS NULL 
        SET @cityid = 1
    INSERT  INTO HrmCityTwo
            ( id ,
              cityname ,
              citylongitude ,
              citylatitude ,
              cityid 
            )
    VALUES  ( @cityid ,
              @cityname ,
              @citylongitude ,
              @citylatitude ,
              @citypid 
            ) 
    SELECT  @cityid
GO


CREATE PROCEDURE HrmCityTwo_Update
    (
      @id INT ,
      @cityname VARCHAR(60) ,
      @citylongitude DECIMAL(8, 3) ,
      @citylatitude DECIMAL(8, 3) ,
      @cityid INT ,
      @flag INTEGER OUTPUT ,
      @msg VARCHAR(80) OUTPUT 
    )
AS 
    UPDATE  HrmCityTwo
    SET     cityname = @cityname ,
            citylongitude = @citylongitude ,
            citylatitude = @citylatitude ,
            cityid = @cityid
    WHERE   ( id = @id )
    IF @@error <> 0 
        BEGIN
            SET @flag = 1
            SET @msg = '插入储存过程失败'
            RETURN
        END
    ELSE 
        BEGIN
            SET @flag = 0
            SET @msg = '插入储存过程成功'
            RETURN
        END
GO

CREATE PROCEDURE HrmCityTwo_Delete
    (
      @id INT ,
      @flag INTEGER OUTPUT ,
      @msg VARCHAR(80) OUTPUT 
    )
AS 
    DELETE  HrmCityTwo
    WHERE   ( id = @id )
    IF @@error <> 0 
        BEGIN
            SET @flag = 1
            SET @msg = '插入储存过程失败' 
            RETURN
        END
    ELSE 
        BEGIN
            SET @flag = 0
            SET @msg = '插入储存过程成功'
            RETURN
        END
GO
