ALTER TABLE HrmUserSetting ADD belongtoshow int
GO
UPDATE MainMenuInfo SET linkAddress='/hrm/jobtitlestemplet/index.jsp'  WHERE id=62
GO
SELECT * INTO HrmJobTitlesTemplet from HrmJobTitles
GO
ALTER TABLE HrmJobTitlesTemplet DROP COLUMN jobdepartmentid 
GO
INSERT INTO SystemLogItem(itemid,lableid,itemdesc,typeid)VALUES(157,82662,'岗位模板',2)
GO
CREATE PROCEDURE HrmJobTitlesTemplet_Select
    @flag INTEGER OUTPUT ,
    @msg VARCHAR(4000) OUTPUT
AS 
    SELECT  *
    FROM    HrmJobTitlesTemplet
    SET @flag = 0
    SET @msg = '操作成功完成' 
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
    FROM    HrmJobTitles
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

CREATE PROCEDURE HrmJobTitlesTemplet_Update
    (
      @id_1 int ,
      @jobtitlemark_2 VARCHAR(4000) ,
      @jobtitlename_3 VARCHAR(4000) ,
      @jobactivityid_5 INT ,
      @jobresponsibility_6 VARCHAR(4000) ,
      @jobcompetency_7 VARCHAR(4000) ,
      @jobtitleremark_8 text ,
      @flag INTEGER OUTPUT ,
      @msg VARCHAR(4000) OUTPUT 
    )
AS 
    UPDATE  HrmJobTitlesTemplet
    SET     jobtitlemark = @jobtitlemark_2 ,
            jobtitlename = @jobtitlename_3 ,
            jobactivityid = @jobactivityid_5 ,
            jobresponsibility = @jobresponsibility_6 ,
            jobcompetency = @jobcompetency_7 ,
            jobtitleremark = @jobtitleremark_8
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

CREATE PROCEDURE HrmJobTitlesTemplet_Delete
    (
      @id_1 int ,
      @flag INTEGER OUTPUT ,
      @msg VARCHAR(4000) OUTPUT 
    )
AS 
    DELETE  HrmJobTitles
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