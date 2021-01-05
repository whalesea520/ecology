ALTER table workflow_base add version int
GO

ALTER table workflow_base add activeVersionID int
GO

ALTER table workflow_base add versionDescription varchar(255)
GO

ALTER table workflow_base add VersionCreater int
GO

create table workflow_versionNodeRelation (
	nodeid int,
	parentNodeid int
)
GO

alter table Workflow_ReportDspField add fieldwidth NUMERIC (10, 2)
GO
alter table Workflow_ReportDspField add reportcondition INT
GO
alter table Workflow_ReportDspField add httype VARCHAR (10)
GO
alter table Workflow_ReportDspField add htdetailtype VARCHAR (10)
GO
alter table Workflow_ReportDspField add valuefour VARCHAR (255)
GO
alter table Workflow_ReportDspField add valueone VARCHAR (255)
GO
alter table Workflow_ReportDspField add valuethree VARCHAR (255)
GO
alter table Workflow_ReportDspField add valuetwo VARCHAR (255)
GO
EXEC sp_rename 'WorkflowReportShare.[userid]','useridbak','COLUMN';
GO
EXEC sp_rename 'WorkflowReportShare.[departmentid]','departmentidbak','COLUMN';
GO
EXEC sp_rename 'WorkflowReportShare.[subcompanyid]','subcompanyidbak','COLUMN';
GO
EXEC sp_rename 'WorkflowReportShare.[roleid]','roleidbak','COLUMN';
GO
EXEC sp_rename 'WorkflowReportShare.[seclevel]','seclevelbak','COLUMN';
GO

ALTER TABLE WorkflowReportShare ADD userid VARCHAR (255)
GO
ALTER TABLE WorkflowReportShare ADD departmentid VARCHAR (255)
GO
ALTER TABLE WorkflowReportShare ADD subcompanyid VARCHAR (255)
GO
ALTER TABLE WorkflowReportShare ADD roleid VARCHAR (255)
GO
ALTER TABLE WorkflowReportShare ADD seclevel INT
GO
UPDATE WorkflowReportShare SET userid = useridbak,departmentid = departmentidbak,subcompanyid =subcompanyidbak,roleid = roleidbak,seclevel = seclevelbak
GO
CREATE VIEW view_workflowForm_selectAll 
  AS
	select id,formname,formdesc,subcompanyid,0 as isoldornew from workflow_formbase 
	union all
	select t1.id,indexdesc,formdes,subcompanyid,1 as isoldornew from workflow_bill t1,HtmlLabelIndex t2 where t1.namelabel=t2.id
GO

CREATE PROCEDURE Wf_Right_checkpermission(		   @dirid_1         INT,
                                                   @dirtype_1       INT,
                                                   @userid_1        INT,
                                                   @usertype_1      INT,
                                                   @seclevel_1      INT,
                                                   @operationcode_1 INT,
                                                   @departmentid_1  INT,
                                                   @subcompanyid_1  INT,
                                                   @roleid_1        VARCHAR(1000),
                                                   @flag            INT output,
                                                   @msg             VARCHAR(80) output)
AS
  DECLARE @count_1 INT
  DECLARE @result INT

  SET @result = 0
BEGIN
	SET @count_1 = (SELECT Count(mainid)
					FROM   wfAccessControlList
					WHERE  dirid = @dirid_1
						   AND dirtype = @dirtype_1
						   AND operationcode = @operationcode_1
						   AND (  (permissiontype=1 
								   AND departmentid = @departmentid_1
								   AND seclevel <= @seclevel_1 )
								  OR(permissiontype=2
									 AND roleid IN (SELECT * FROM   Splitstr(@roleid_1, ','))
									 AND seclevel <= @seclevel_1 )
								  OR( permissiontype = 3
									  AND seclevel <= @seclevel_1 )
								  OR( permissiontype = 4
									  AND usertype = @usertype_1
									  AND seclevel <= @seclevel_1 )
								  OR( permissiontype = 5
									  AND userid = @userid_1)
								  OR( permissiontype = 6
									  AND subcompanyid=@subcompanyid_1
									  AND seclevel <= @seclevel_1) ))
END

  PRINT @count_1

  IF ( NOT ( @count_1 IS NULL ) )
     AND ( @count_1 > 0 )
    BEGIN
        SET @result = 1
    END

  SELECT @result result

  IF @@ERROR <> 0
    BEGIN
        SET @flag=1
        SET @msg='检查流程访问权限成功'

        RETURN
    END
  ELSE
    BEGIN
        SET @flag=-1
        SET @msg='检查流程访问权限失败'

        RETURN
    END 
    
GO


CREATE PROCEDURE Wf_Right_checkpermission2(	   @dirtype_1       INT,
                                                   @userid_1        INT,
                                                   @usertype_1      INT,
                                                   @seclevel_1      INT,
                                                   @operationcode_1 INT,
                                                   @departmentid_1  INT,
                                                   @subcompanyid_1  INT,
                                                   @roleid_1        VARCHAR(1000),
                                                   @flag            INT output,
                                                   @msg             VARCHAR(80) output)
AS
  DECLARE @count_1 INT
  DECLARE @result INT

  SET @result = 0
BEGIN
	SET @count_1 = (SELECT Count(mainid)
					FROM   wfAccessControlList
					WHERE  dirtype = @dirtype_1
						   AND operationcode = @operationcode_1
						   AND (  (permissiontype=1 
								   AND departmentid = @departmentid_1
								   AND seclevel <= @seclevel_1 )
								  OR(permissiontype=2
									 AND roleid IN (SELECT * FROM   Splitstr(@roleid_1, ','))
									 AND seclevel <= @seclevel_1 )
								  OR( permissiontype = 3
									  AND seclevel <= @seclevel_1 )
								  OR( permissiontype = 4
									  AND usertype = @usertype_1
									  AND seclevel <= @seclevel_1 )
								  OR( permissiontype = 5
									  AND userid = @userid_1)
								  OR( permissiontype = 6
									  AND subcompanyid=@subcompanyid_1
									  AND seclevel <= @seclevel_1) ))
END

  PRINT @count_1

  IF ( NOT ( @count_1 IS NULL ) )
     AND ( @count_1 > 0 )
    BEGIN
        SET @result = 1
    END

  SELECT @result result

  IF @@ERROR <> 0
    BEGIN
        SET @flag=1
        SET @msg='检查流程访问权限成功'

        RETURN
    END
  ELSE
    BEGIN
        SET @flag=-1
        SET @msg='检查流程访问权限失败'

        RETURN
    END 
    
GO


CREATE PROCEDURE Wf_Right_delete(		  @mainid_1 INT,
                                          @flag     INT output,
                                          @msg      VARCHAR(80) output)
AS
  DELETE FROM wfAccessControlList
  WHERE  mainid = @mainid_1

  IF @@ERROR <> 0
    BEGIN
        SET @flag=1
        SET @msg='删除流程访问权限表成功'

        RETURN
    END
  ELSE
    BEGIN
        SET @flag=0
        SET @msg='删除流程访问权限表失败'

        RETURN
    END 
    
GO


CREATE PROCEDURE Wf_Right_insert_type1(			@dirid_1         INT,
                                                @dirtype_1       INT,
                                                @operationcode_1 INT,
                                                @departmentid_1  INT,
                                                @seclevel_1      INT,
                                                @flag            INT output,
                                                @msg             VARCHAR(80) output)
AS
  INSERT INTO wfAccessControlList
              (dirid,
               dirtype,
               departmentid,
               seclevel,
               operationcode,
               permissiontype)
  VALUES     (@dirid_1,
              @dirtype_1,
              @departmentid_1,
              @seclevel_1,
              @operationcode_1,
              1)

  IF @@ERROR <> 0
    BEGIN
        SET @flag=1
        SET @msg='插入流程访问权限主表成功'

        RETURN
    END
  ELSE
    BEGIN
        SET @flag=0
        SET @msg='插入流程访问权限主表失败'

        RETURN
    END 
    
GO

CREATE PROCEDURE Wf_Right_insert_type2 (		@dirid_1         INT,
                                                @dirtype_1       INT,
                                                @operationcode_1 INT,
                                                @roleid_1        INT,
                                                @rolelevel_1     INT,
                                                @seclevel_1      INT,
                                                @flag            INT output,
                                                @msg             VARCHAR(80) output)
AS
  INSERT INTO wfAccessControlList
              (dirid,
               dirtype,
               roleid,
               rolelevel,
               seclevel,
               operationcode,
               permissiontype)
  VALUES     (@dirid_1,
              @dirtype_1,
              @roleid_1,
              @rolelevel_1,
              @seclevel_1,
              @operationcode_1,
              2)

  IF @@ERROR <> 0
    BEGIN
        SET @flag=1
        SET @msg='插入流程访问权限主表成功'

        RETURN
    END
  ELSE
    BEGIN
        SET @flag=0
        SET @msg='插入流程访问权限主表失败'

        RETURN
    END 

GO


CREATE PROCEDURE Wf_Right_insert_type3(			@dirid_1         INT,
                                                @dirtype_1       INT,
                                                @operationcode_1 INT,
                                                @seclevel_1      INT,
                                                @flag            INT output,
                                                @msg             VARCHAR(80) output)
AS
  INSERT INTO wfAccessControlList
              (dirid,
               dirtype,
               seclevel,
               operationcode,
               permissiontype)
  VALUES     (@dirid_1,
              @dirtype_1,
              @seclevel_1,
              @operationcode_1,
              3)

  IF @@ERROR <> 0
    BEGIN
        SET @flag=1
        SET @msg='插入流程访问权限主表成功'

        RETURN
    END
  ELSE
    BEGIN
        SET @flag=0
        SET @msg='插入流程访问权限主表失败'

        RETURN
    END 

GO


CREATE PROCEDURE Wf_Right_insert_type4(			@dirid_1         INT,
                                                @dirtype_1       INT,
                                                @operationcode_1 INT,
                                                @usertype_1      INT,
                                                @seclevel_1      INT,
                                                @flag            INT output,
                                                @msg             VARCHAR(80) output)
AS
  INSERT INTO wfAccessControlList
              (dirid,
               dirtype,
               usertype,
               seclevel,
               operationcode,
               permissiontype)
  VALUES     (@dirid_1,
              @dirtype_1,
              @usertype_1,
              @seclevel_1,
              @operationcode_1,
              4)

  IF @@ERROR <> 0
    BEGIN
        SET @flag=1
        SET @msg='插入流程访问权限主表成功'

        RETURN
    END
  ELSE
    BEGIN
        SET @flag=0
        SET @msg='插入流程访问权限主表失败'

        RETURN
    END 
    
GO

CREATE PROCEDURE Wf_Right_insert_type5(			@dirid_1         INT,
                                                @dirtype_1       INT,
                                                @operationcode_1 INT,
                                                @userid_1        INT,
                                                @flag            INT output,
                                                @msg             VARCHAR(80) output)
AS
  INSERT INTO wfAccessControlList
              (dirid,
               dirtype,
               userid,
               operationcode,
               permissiontype)
  VALUES     (@dirid_1,
              @dirtype_1,
              @userid_1,
              @operationcode_1,
              5)

  IF @@ERROR <> 0
    BEGIN
        SET @flag=1
        SET @msg='插入流程访问权限主表成功'

        RETURN
    END
  ELSE
    BEGIN
        SET @flag=0
        SET @msg='插入流程访问权限主表失败'

        RETURN
    END 

GO

CREATE PROCEDURE Wf_Right_insert_type6(			@dirid_1         INT,
                                                @dirtype_1       INT,
                                                @operationcode_1 INT,
                                                @subcompanyid_1  INT,
                                                @seclevel_1      INT,
                                                @flag            INT output,
                                                @msg             VARCHAR(80) output)
AS
  INSERT INTO wfAccessControlList
              (dirid,
               dirtype,
               subcompanyid,
               seclevel,
               operationcode,
               permissiontype)
  VALUES     (@dirid_1,
              @dirtype_1,
              @subcompanyid_1,
              @seclevel_1,
              @operationcode_1,
              6)

  IF @@ERROR <> 0
    BEGIN
        SET @flag=1
        SET @msg='插入流程访问权限主表成功'

        RETURN
    END
  ELSE
    BEGIN
        SET @flag=0
        SET @msg='插入流程访问权限主表失败'

        RETURN
    END 
    
GO

alter table datashowset add name varchar(200)
GO

create table rule_base(
	id int IDENTITY(1,1) NOT NULL,
	rulesrc int NULL,
	formid int NULL,
	linkid int NULL,
	isbill int NULL,
	rulename varchar(500) NULL,
	ruledesc varchar(1000) NULL,
	condit varchar(2000) NULL
)
GO
create table rule_expressionbase(
	id int NOT NULL,
	ruleid int NULL,
	datafield int NULL,
	datafieldtext varchar(200) NULL,
	compareoption1 int NULL,
	compareoption2 int NULL,
	htmltype int NULL,
	typehrm int NULL,
	fieldtype varchar(10) NULL,
	valuetype int NULL,
	paramtype int NULL,
	elementvalue1 varchar(1000) NULL,
	elementlabel1 varchar(1000) NULL,
	elementvalue2 varchar(1000) NULL
)
GO
create table rule_expressions(
	id int NOT NULL,
	ruleid int NULL,
	relation int NULL,
	expids varchar(1000) NULL,
	expbaseid int NULL
)
GO

create table wfnodegeneralmode(
	id int IDENTITY(1,1) NOT NULL,
	modename varchar(200) NULL,
	formid int NULL,
	isbill int NULL,
	wfid int NULL,
	nodeid int NULL
)
GO

alter table workflow_base add dsporder int
GO
update workflow_base set dsporder = 0 where dsporder is null or dsporder = ''
GO


