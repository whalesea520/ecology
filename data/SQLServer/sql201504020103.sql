DROP PROCEDURE HrmJobTitlesTemplet_Insert
GO
CREATE PROCEDURE HrmJobTitlesTemplet_Insert
    (
      @jobtitlemark_1 VARCHAR(4000) ,
      @jobtitlename_2 VARCHAR(4000) ,
      @jobactivityid_4 INT ,
      @jobresponsibility_5 VARCHAR(4000) ,
      @jobcompetency_6 VARCHAR(4000) ,
      @jobtitleremark_7 text ,
      @flag INTEGER OUTPUT ,
      @msg VARCHAR(4000) OUTPUT 
    )
AS 
    INSERT  INTO HrmJobTitlesTemplet
            ( jobtitlemark ,
              jobtitlename ,
              jobactivityid ,
              jobresponsibility ,
              jobcompetency ,
              jobtitleremark
            )
    VALUES  ( @jobtitlemark_1 ,
              @jobtitlename_2 ,
              @jobactivityid_4 ,
              @jobresponsibility_5 ,
              @jobcompetency_6 ,
              @jobtitleremark_7
            )
    SELECT  MAX(id)
    FROM    HrmJobTitlesTemplet
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

DROP PROCEDURE HrmJobTitlesTemplet_Delete
GO
CREATE PROCEDURE HrmJobTitlesTemplet_Delete
    (
      @id_1 int ,
      @flag INTEGER OUTPUT ,
      @msg VARCHAR(4000) OUTPUT 
    )
AS 
    DELETE  HrmJobTitlesTemplet
    WHERE   ( id = @id_1 )
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
