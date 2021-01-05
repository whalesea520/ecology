ALTER PROCEDURE [HrmProvince_Insert](
               @provincename_1 VARCHAR(4000),@provincedesc_2 VARCHAR(4000),@countryid_3 [INT],@flag INTEGER  OUTPUT,@msg VARCHAR(4000)  OUTPUT)
AS
  DECLARE  @maxid INT
  SELECT @maxid =  (ISNULL(MAX(id),0)
                    + 1)
  FROM   hrmprovince
  INSERT INTO [hrmprovince]
             ([id],[provincename],[provincedesc],[countryid])
  VALUES     (@maxid,@provincename_1,@provincedesc_2,@countryid_3)
  SELECT MAX(id)
  FROM   [hrmprovince]
  IF @@ERROR <> 0
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
go
ALTER PROCEDURE [hrmcity_insert](
               @cityname VARCHAR(4000),@citylongitude DECIMAL(8,3),@citylatitude DECIMAL(8,3),@provinceid INT,@countryid INT,@flag INTEGER  OUTPUT,@msg VARCHAR(4000)  OUTPUT)
AS
  DECLARE  @cityid INT
  SELECT @cityid = (ISNULL(MAX(id),0)
                      + 1)
  FROM   hrmcity
  INSERT INTO hrmcity
             (id,cityname,citylongitude,citylatitude,provinceid,countryid)
  VALUES     (@cityid,@cityname,@citylongitude,@citylatitude,@provinceid,@countryid)
  SELECT @cityid
go
ALTER PROCEDURE [hrmcitytwo_insert](
               @cityname VARCHAR(4000),@citylongitude DECIMAL(8,3),@citylatitude DECIMAL(8,3),@citypid INT,@flag INTEGER  OUTPUT,@msg VARCHAR(4000)  OUTPUT)
AS
  DECLARE  @cityid INT
  SELECT @cityid = (ISNULL(MAX(id),0)
                      + 1)
  FROM   hrmcitytwo
  IF @cityid IS NULL
    SET @cityid = 1
  INSERT INTO hrmcitytwo
             (id,cityname,citylongitude,citylatitude,cityid)
  VALUES     (@cityid,@cityname,@citylongitude,@citylatitude,@citypid)
  SELECT @cityid
go