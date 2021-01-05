ALTER TABLE SystemSet ADD hrmdetachable INTEGER
GO
ALTER TABLE SystemSet ADD hrmdftsubcomid INTEGER
GO

ALTER TABLE SystemSet ADD wfdetachable INTEGER
GO
ALTER TABLE SystemSet ADD wfdftsubcomid INTEGER
GO

ALTER TABLE SystemSet ADD docdetachable INTEGER
GO
ALTER TABLE SystemSet ADD docdftsubcomid INTEGER
GO

ALTER TABLE SystemSet ADD portaldetachable INTEGER
GO
ALTER TABLE SystemSet ADD portaldftsubcomid INTEGER
GO

ALTER TABLE SystemSet ADD cptdetachable INTEGER
GO
ALTER TABLE SystemSet ADD cptdftsubcomid INTEGER
GO

ALTER TABLE SystemSet ADD mtidetachable INTEGER
GO
ALTER TABLE SystemSet ADD mtidftsubcomid INTEGER
GO

ALTER TABLE SystemSet ADD wcdetachable INTEGER
GO
ALTER TABLE SystemSet ADD wcdftsubcomid INTEGER
GO

ALTER TABLE hrmresourcemanager ADD subcompanyids varchar(4000)
GO


ALTER TABLE SysDetachDetail DROP COLUMN type
GO

ALTER TABLE SysDetachDetail ADD type1 INTEGER
GO

ALTER PROCEDURE SystemDMSet_Update
 ( 
 @detachable_1 char(1) , 
 @dftsubcomid_2 int , 
 @hrmdetachable_3 char(1) , 
 @hrmdftsubcomid_4 int , 
 @wfdetachable_5 char(1) , 
 @wfdftsubcomid_6 int ,   
 @docdetachable_7 char(1) , 
 @docdftsubcomid_8 int , 
 @portaldetachable_9 char(1) , 
 @portaldftsubcomid_10 int , 
 @cptdetachable_11 char(1) , 
 @cptdftsubcomid_12 int , 
 @mtidetachable_13 char(1) , 
 @mtidftsubcomid_14 int ,    
 @flag int output , 
 @msg varchar(80) output
 ) 
 AS 
 update SystemSet set 
        detachable=@detachable_1 ,
        dftsubcomid=@dftsubcomid_2,
        hrmdetachable=@hrmdetachable_3,
        hrmdftsubcomid=@hrmdftsubcomid_4, 
        wfdetachable=@wfdetachable_5,
        wfdftsubcomid=@wfdftsubcomid_6, 
        docdetachable=@docdetachable_7,
        docdftsubcomid=@docdftsubcomid_8,
        portaldetachable=@portaldetachable_9,
        portaldftsubcomid=@portaldftsubcomid_10,   
        cptdetachable=@cptdetachable_11,
        cptdftsubcomid=@cptdftsubcomid_12, 
        mtidetachable=@mtidetachable_13,
        mtidftsubcomid=@mtidftsubcomid_14                                         
GO


 ALTER PROCEDURE SystemSet_DftSCUpdate 
 ( 
 @dftsubcomid int , 
 @hrmdftsubcomid int , 
 @wfdftsubcomid int , 
 @docdftsubcomid int , 
 @portaldftsubcomid int , 
 @cptdftsubcomid int , 
 @mtidftsubcomid int ,       
 @flag int output , 
 @msg varchar(80) output 
 ) 
 AS 
  
  update HrmRoles set subcompanyid=@hrmdftsubcomid 
  where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany)  
  
  update HrmContractTemplet set subcompanyid=@hrmdftsubcomid 
  where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany)  
  
  update HrmContractType set subcompanyid=@hrmdftsubcomid 
  where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany) 

  update HrmCareerApply set subCompanyId=@hrmdftsubcomid 
  where subCompanyId is null or subCompanyId=0 or subCompanyId=-1 or subCompanyId not in (select id from hrmsubcompany)  
  
  update workflow_formdict set subcompanyid=@wfdftsubcomid 
  where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany)  
  
  update workflow_formdictdetail set subcompanyid=@wfdftsubcomid 
  where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany)  
  
  update workflow_formbase set subcompanyid=@wfdftsubcomid 
  where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany)  
  
  update workflow_base set subcompanyid=@wfdftsubcomid 
  where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany)  
  
  update cptcapital set blongsubcompany=@cptdftsubcomid 
  where blongsubcompany is null or blongsubcompany=0 or blongsubcompany=-1 or blongsubcompany not in (select id from hrmsubcompany)  

  UPDATE MeetingRoom SET  subcompanyId = @mtidftsubcomid 
  WHERE subcompanyId IS null OR subcompanyId = 0 OR subcompanyId = -1 OR subcompanyid NOT IN (SELECT id FROM hrmSubcompany)  
  
  UPDATE Meeting_Type SET subcompanyId = @mtidftsubcomid 
  WHERE subcompanyId IS null OR subcompanyId = 0 OR subcompanyId = -1 OR subcompanyid NOT IN (SELECT id FROM hrmSubcompany)   

GO



create table moduleManageDetach
(
  ID                       int IDENTITY(1,1) NOT NULL,
  manageType               CHAR(2),
  administrators           VARCHAR(4000),
  Seclevel                 int,
  hrmSubcomids             VARCHAR(4000),
  wfSubcomids              VARCHAR(4000),
  docSubcomids             VARCHAR(4000),
  portalSubcomids          VARCHAR(4000),
  cptSubcomids             VARCHAR(4000),
  mtiSubcomids             VARCHAR(4000),
  created_by               int,
  created_date             VARCHAR(20),
  updated_by               int,
  updated_date             VARCHAR(20),  
  remark                   VARCHAR(400)
)
GO

create table effectManageEmpower
(
  ID                       int IDENTITY(1,1) NOT NULL,
  manageType               CHAR(2),
  administrators           VARCHAR(4000),
  Seclevel                 INTEGER,
  workflowTypes            VARCHAR(4000),
  docmaincategorys         VARCHAR(4000),
  portalTypes              VARCHAR(4000),
  coworkTypes              VARCHAR(4000),
  created_by               INTEGER,
  created_date             VARCHAR(20),
  updated_by               INTEGER,
  updated_date             VARCHAR(20),
  remark                   VARCHAR(400)
)
GO

CREATE TABLE hrmroles_module(
  id             int  NOT NULL,
  rolesmark      varchar(60) NULL,                  
  rolesname      varchar(200) NULL,                 
  docid          int NULL,                           
  isdefault      char(1) NULL,                       
  type           int NULL,                           
  subcompanyid   int NULL                            
)
GO

CREATE TABLE wfAccessControlList(
  mainid                    int IDENTITY(1,1) NOT NULL,
  dirid                     int NOT NULL,
  dirtype                   int NULL,
  seclevel                  int NULL,
  departmentid              int NULL,
  roleid                    int NULL,
  rolelevel                 int NULL,
  usertype                  int NULL,
  permissiontype            int NOT NULL,
  operationcode             int NULL,
  userid                    int NULL,
  DocSecCategoryTemplateId  int NULL,
  subcompanyid              int NULL
  )
GO

CREATE TABLE ptAccessControlList(
  mainid                    int IDENTITY(1,1) NOT NULL,
  dirid                     int NOT NULL,
  dirtype                   int NULL,
  seclevel                  int NULL,
  departmentid              int NULL,
  roleid                    int NULL,
  rolelevel                 int NULL,
  usertype                  int NULL,
  permissiontype            int NOT NULL,
  operationcode             int NULL,
  userid                    int NULL,
  DocSecCategoryTemplateId  int NULL,
  subcompanyid              int NULL
  )
GO

CREATE TABLE cwAccessControlList(
  mainid                    int IDENTITY(1,1) NOT NULL,
  dirid                     int NOT NULL,
  dirtype                   int NULL,
  seclevel                  int NULL,
  departmentid              int NULL,
  roleid                    int NULL,
  rolelevel                 int NULL,
  usertype                  int NULL,
  permissiontype            int NOT NULL,
  operationcode             int NULL,
  userid                    int NULL,
  DocSecCategoryTemplateId  int NULL,
  subcompanyid              int NULL
  )
GO



ALTER table SysDetachDetail add operator char(2)
GO
ALTER table SysDetachDetail add rolelevel char(1)
GO
alter table HrmGroup add sn decimal(5,2) default 0
GO
update HrmGroup set sn = 0
GO
CREATE TABLE Hrm_Rp_Sub_Template(
	id int NOT NULL identity(1,1) primary key,
	name varchar(50) NOT NULL,
	author int NOT NULL,
	create_date datetime NOT NULL,
	scope varchar(50) NOT NULL,
	delflag int NOT NULL
)
GO
CREATE TABLE hrm_rp_sub_template_con(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	template_id int NOT NULL,
	col_name varchar(50) NULL,
	con_htmltype varchar(50) NULL,
	con_type varchar(50) NULL,
	con_opt varchar(50) NULL,
	con_value varchar(50) NULL,
	con_opt1 varchar(50) NULL,
	con_value1 varchar(50) NULL
)
GO
alter table HrmRpSubDefine alter column scopeid varchar(50) 
GO
alter table HrmRpSubDefine alter column colname varchar(50)
GO
alter table HrmRpSubDefine add templateid int default 0
GO
update HrmRpSubDefine set templateid = 0
GO
alter table HrmRpSubDefine alter column showorder decimal(5,2)
GO
alter table HrmCheckPost add deptid int default 0
GO
alter table HrmCheckPost add subcid int default 0
GO
update HrmCheckPost set deptid=0, subcid=0
GO

update cus_formfield set  isuse='1' where scope='ProjCustomField' and isuse is null
GO
ALTER TABLE HrmListValidate
ADD parentid INT
GO
ALTER TABLE HrmListValidate
ADD TAB_url VARCHAR(500)
GO
ALTER TABLE HrmListValidate
ADD tab_type INT
GO
ALTER TABLE HrmListValidate
ADD tab_index INT
GO
UPDATE HrmListValidate SET parentid =29 WHERE id IN(24,26,27,28)
GO
UPDATE HrmListValidate SET parentid =36 WHERE id IN(36,37,38,39)
GO
UPDATE HrmListValidate SET tab_type=2 WHERE tab_url IS NOT null
GO
ALTER TABLE HrmArrangeShiftSet
ADD arrangeShiftType INT
GO
ALTER TABLE HrmArrangeShiftSet
ADD relatedId INT
GO
ALTER TABLE HrmArrangeShiftSet
ADD levelfrom INT
GO
ALTER TABLE HrmArrangeShiftSet
ADD levelto INT
GO
ALTER TABLE hrmkqsystemSet
ADD needsign INT
GO

ALTER TABLE hrmkqsystemSet 
ADD onlyworkday INT
GO
ALTER TABLE hrmkqsystemSet 
ADD signTimeScope VARCHAR(500)
GO
CREATE TABLE HrmBirthdayShare(
	id int IDENTITY(1,1) NOT NULL,
	sharetype int NULL,
	seclevel tinyint NULL,
	rolelevel tinyint NULL,
	sharelevel tinyint NULL,
	userid int NULL,
	subcompanyid int NULL,
	departmentid int NULL,
	roleid int NULL,
	foralluser tinyint NULL
	)
GO
ALTER TABLE hrmresource
ADD mobileshowtype INT
GO
ALTER PROCEDURE HrmResourceBasicInfo_Insert
    (
      @id_1 INT ,
      @workcode_2 VARCHAR(60) ,
      @lastname_3 VARCHAR(60) ,
      @sex_5 CHAR(1) ,
      @resoureimageid_6 INT ,
      @departmentid_7 INT ,
      @costcenterid_8 INT ,
      @jobtitle_9 INT ,
      @joblevel_10 INT ,
      @jobactivitydesc_11 VARCHAR(200) ,
      @managerid_12 INT ,
      @assistantid_13 INT ,
      @status_14 CHAR(1) ,
      @locationid_15 INT ,
      @workroom_16 VARCHAR(60) ,
      @telephone_17 VARCHAR(60) ,
      @mobile_18 VARCHAR(60) ,
      @mobilecall_19 VARCHAR(30) ,
      @fax_20 VARCHAR(60) ,
      @jobcall_21 INT ,
      @subcompanyid1_22 INT ,
      @managerstr_23 VARCHAR(500) ,
      @accounttype_24 INT ,
      @belongto_25 INT ,
      @systemlanguage_26 INT ,
      @email_27 VARCHAR(60) ,
      @dsporder_28 INT ,
      @mobileshowtype_27 int ,
      @flag INT OUTPUT ,
      @msg VARCHAR(60) OUTPUT
    )
AS 
    INSERT  INTO HrmResource
            ( id ,
              workcode ,
              lastname ,
              sex ,
              resourceimageid ,
              departmentid ,
              costcenterid ,
              jobtitle ,
              joblevel ,
              jobactivitydesc ,
              managerid ,
              assistantid ,
              status ,
              locationid ,
              workroom ,
              telephone ,
              mobile ,
              mobileshowtype,
              mobilecall ,
              fax ,
              jobcall ,
              seclevel ,
              subcompanyid1 ,
              managerstr ,
              accounttype ,
              belongto ,
              systemlanguage ,
              email,
              dsporder
            )
    VALUES  ( @id_1 ,
              @workcode_2 ,
              @lastname_3 ,
              @sex_5 ,
              @resoureimageid_6 ,
              @departmentid_7 ,
              @costcenterid_8 ,
              @jobtitle_9 ,
              @joblevel_10 ,
              @jobactivitydesc_11 ,
              @managerid_12 ,
              @assistantid_13 ,
              @status_14 ,
              @locationid_15 ,
              @workroom_16 ,
              @telephone_17 ,
              @mobile_18 ,
              @mobileshowtype_27,
              @mobilecall_19 ,
              @fax_20 ,
              @jobcall_21 ,
              0 ,
              @subcompanyid1_22 ,
              @managerstr_23 ,
              @accounttype_24 ,
              @belongto_25 ,
              @systemlanguage_26 ,
              @email_27,
              @dsporder_28
            )
GO
            INSERT INTO cus_treeform 
        ( scope ,
          formlabel ,
          id ,
          parentid ,
          viewtype ,
          scopeorder
        )
VALUES  ( 'HrmCustomFieldByInfoType' ,
          '基本信息' , 
          -1 , 
          0 , 
          '0' , 
          0  
        )
        
GO

CREATE TABLE TmpOnlineUserId (id INT PRIMARY KEY)
GO
ALTER TABLE subcompanyDefineField 
ADD ismand CHAR(1)
GO
ALTER TABLE departmentDefineField 
ADD ismand CHAR(1)
GO
INSERT INTO HrmListValidate(id, name, validate_n, tab_index,tab_type) VALUES(29,'工作历程',1,2,1)
GO
INSERT INTO HrmListValidate(id, name, validate_n, tab_index,tab_type) VALUES(30,'快捷功能',1,99,1)
GO
INSERT INTO HrmListValidate(id, name, validate_n, tab_index,tab_type, parentid) VALUES(31,'发送短信',1,1,1,30)
GO
INSERT INTO HrmListValidate(id, name, validate_n, tab_index,tab_type, parentid) VALUES(32,'新建日程',1,2,1,30)
GO
INSERT INTO HrmListValidate(id, name, validate_n, tab_index,tab_type, parentid) VALUES(33,'新建协作',1,3,1,30)
GO
UPDATE HrmListValidate SET tab_type=1 WHERE id<29
GO
UPDATE HrmListValidate SET tab_index =1 WHERE id=3
GO
UPDATE HrmListValidate SET tab_index =3 WHERE id=11
GO
UPDATE HrmListValidate SET tab_index =4 WHERE id=12
GO
UPDATE HrmListValidate SET tab_index =6 WHERE id=13
GO
UPDATE HrmListValidate SET tab_index =7 WHERE id=14
GO
UPDATE HrmListValidate SET tab_index =5 WHERE id=15
GO
UPDATE HrmListValidate SET tab_index =8 WHERE id=17
GO
UPDATE HrmListValidate SET tab_index =9 WHERE id=18
GO
UPDATE HrmListValidate SET tab_index =1, parentid=30 WHERE id=19
GO
UPDATE HrmListValidate SET tab_index =11 WHERE id=20
GO
UPDATE HrmListValidate SET tab_index =12 WHERE id=21
GO
UPDATE HrmListValidate SET tab_index =13 WHERE id=22
GO
UPDATE HrmListValidate SET tab_index =10 WHERE id=23
GO
UPDATE HrmListValidate SET parentid=29 WHERE id=24
GO
UPDATE HrmListValidate SET parentid=29 WHERE id=26
GO
UPDATE HrmListValidate SET parentid=29 WHERE id=27
GO
UPDATE HrmListValidate SET parentid=29 WHERE id=28
GO
UPDATE HrmListValidate SET tab_index=99 WHERE tab_index IS NULL
Delete from MainMenuInfo where id=1339
GO

 CREATE PROCEDURE HrmBirthdayShare_Insert
    (
      @sharetype_1 INT ,
      @seclevel_1 TINYINT ,
      @rolelevel_1 TINYINT ,
      @sharelevel_1 TINYINT ,
      @userid_1 INT ,
      @subcompanyid_1 INT ,
      @departmentid_1 INT ,
      @roleid_1 INT ,
      @foralluser_1 TINYINT ,
      @flag INT OUTPUT ,
      @msg VARCHAR(80) OUTPUT
    )
 AS 
    INSERT  INTO HrmBirthdayShare
            ( 
              sharetype ,
              seclevel ,
              rolelevel ,
              sharelevel ,
              userid ,
              subcompanyid ,
              departmentid ,
              roleid ,
              foralluser
            )
    VALUES  ( 
              @sharetype_1 ,
              @seclevel_1 ,
              @rolelevel_1 ,
              @sharelevel_1 ,
              @userid_1 ,
              @subcompanyid_1 ,
              @departmentid_1 ,
              @roleid_1 ,
              @foralluser_1
            ) 
GO

CREATE PROCEDURE HrmBirthdayShare_Delete
    (
      @id INT ,
      @flag INT OUTPUT ,
      @msg VARCHAR(80) OUTPUT
    )
AS 
    DELETE  FROM HrmBirthdayShare
    WHERE   id = @id  
GO    

alter table HrmTrainDay
add starttime char(5)
GO
alter table HrmTrainDay
add endtime char(5)
GO
ALTER PROCEDURE HrmTrainDay_Insert
    (
      @trainid_1 INT ,
      @day_2 CHAR(10) ,
      @starttime CHAR(5),
      @endtime CHAR(5),
      @content_3 TEXT ,
      @aim_4 TEXT ,
      @flag INT OUTPUT ,
      @msg VARCHAR(60) OUTPUT
    )
AS 
    INSERT  INTO HrmTrainDay
            ( trainid ,
              traindate ,
              starttime,
              endtime,
              daytraincontent ,
              daytrainaim
            )
    VALUES  ( @trainid_1 ,
              @day_2 ,
              @starttime,
              @endtime,
              @content_3 ,
              @aim_4
            )
    SELECT  MAX(id)
    FROM    HrmTrainDay
GO
ALTER PROCEDURE HrmTrainDay_Update
    (
      @day_1 CHAR(10) ,
      @starttime CHAR(5),
      @endtime CHAR(5),
      @content_2 TEXT ,
      @aim_3 TEXT ,
      @effect_4 TEXT ,
      @plain_5 TEXT ,
      @id_6 INT ,
      @flag INT OUTPUT ,
      @msg VARCHAR(60) OUTPUT
    )
AS 
    UPDATE  HrmTrainDay
    SET     traindate = @day_1 ,
			starttime = @starttime,
			endtime = @endtime,
            daytraincontent = @content_2 ,
            daytrainaim = @aim_3 ,
            daytraineffect = @effect_4 ,
            daytrainplain = @plain_5
    WHERE   id = @id_6
GO 

CREATE TABLE HrmScheduleSignSet
(
datasourceid VARCHAR(50) PRIMARY KEY,
importtype CHAR(1),
tablename VARCHAR(50),
workcode VARCHAR(50),
lastname VARCHAR(50),
usertype VARCHAR(50),
signtype VARCHAR(50),
signdate VARCHAR(50), 
signtime VARCHAR(50), 
clientaddress VARCHAR(50),
isincom VARCHAR(50)
)
GO

DELETE FROM HrmListValidate WHERE name  IN ('日志','密码')
GO
ALTER PROCEDURE HrmResourceContactInfo_Update
    (
      @id_1 INT ,
      @locationid_15 INT ,
      @workroom_16 VARCHAR(60) ,
      @telephone_17 VARCHAR(60) ,
      @mobile_18 VARCHAR(60) ,
      @mobileshowtype_18 VARCHAR(60) ,
      @mobilecall_19 VARCHAR(30) ,
      @fax_20 VARCHAR(60) ,
      @systemlanguage_21 INT ,
      @email_22 VARCHAR(60) ,
      @flag INT OUTPUT ,
      @msg VARCHAR(60) OUTPUT
    )
AS 
    UPDATE  HrmResource
    SET     locationid = @locationid_15 ,
            workroom = @workroom_16 ,
            telephone = @telephone_17 ,
            mobile = @mobile_18 ,
            mobileshowtype = @mobileshowtype_18 ,
            mobilecall = @mobilecall_19 ,
            fax = @fax_20 ,
            email = @email_22 ,
            systemlanguage = @systemlanguage_21
    WHERE   id = @id_1
GO

INSERT INTO HrmListValidate (id, name,validate_n,parentid,TAB_url,tab_type,tab_index)
values (35,'当前考核',1,29,NULL,1,100)
GO
UPDATE HrmListValidate SET name = '工资福利' WHERE name='财务信息'
GO
UPDATE HrmListValidate SET name = '待办事宜' WHERE name='工作流'
GO
UPDATE HrmListValidate SET name = '日程安排' WHERE name='计划'
GO
UPDATE HrmListValidate SET name = '考勤情况' WHERE name='考勤'
GO
UPDATE HrmListValidate SET name = '奖惩考核' WHERE name='奖惩记录'
GO
UPDATE HrmListValidate SET name = '发送邮件' WHERE name='邮件发送 '
GO
ALTER TABLE SystemLogItem ADD typeid INT
GO
delete from SystemLogItem where itemid='301'
GO
insert into SystemLogItem values('301',30041,'文档',1)
GO
INSERT INTO SystemLogItem (itemid, lableid, itemdesc,typeid) 
VALUES (166,32744,'自定义显示栏目',179)
GO
UPDATE HrmListValidate SET name='考勤情况' WHERE name = '考勤管理'
GO
UPDATE HrmListValidate SET name='培训记录' WHERE name = '培训管理'
GO
ALTER TABLE HrmResource ADD usbstate int 
GO
ALTER PROCEDURE HrmResourceContactInfo_Update
    (
      @id_1 INT ,
      @locationid_15 INT ,
      @workroom_16 VARCHAR(60) ,
      @telephone_17 VARCHAR(60) ,
      @mobile_18 VARCHAR(60) ,
      @mobilecall_19 VARCHAR(30) ,
      @fax_20 VARCHAR(60) ,
      @systemlanguage_21 INT ,
      @email_22 VARCHAR(60) ,
      @mobileshowtype_23 VARCHAR(60) =null,
      @flag INT OUTPUT ,
      @msg VARCHAR(60) OUTPUT
    )
AS 
    UPDATE  HrmResource
    SET     locationid = @locationid_15 ,
            workroom = @workroom_16 ,
            telephone = @telephone_17 ,
            mobile = @mobile_18 ,
            mobileshowtype = @mobileshowtype_23 ,
            mobilecall = @mobilecall_19 ,
            fax = @fax_20 ,
            email = @email_22 ,
            systemlanguage = @systemlanguage_21
    WHERE   id = @id_1
  GO
    ALTER PROCEDURE HrmResourceBasicInfo_Insert
    (
      @id_1 INT ,
      @workcode_2 VARCHAR(60) ,
      @lastname_3 VARCHAR(60) ,
      @sex_5 CHAR(1) ,
      @resoureimageid_6 INT ,
      @departmentid_7 INT ,
      @costcenterid_8 INT ,
      @jobtitle_9 INT ,
      @joblevel_10 INT ,
      @jobactivitydesc_11 VARCHAR(200) ,
      @managerid_12 INT ,
      @assistantid_13 INT ,
      @status_14 CHAR(1) ,
      @locationid_15 INT ,
      @workroom_16 VARCHAR(60) ,
      @telephone_17 VARCHAR(60) ,
      @mobile_18 VARCHAR(60) ,
      @mobilecall_19 VARCHAR(30) ,
      @fax_20 VARCHAR(60) ,
      @jobcall_21 INT ,
      @subcompanyid1_22 INT ,
      @managerstr_23 VARCHAR(500) ,
      @accounttype_24 INT ,
      @belongto_25 INT ,
      @systemlanguage_26 INT ,
      @email_27 VARCHAR(60)=NULL ,
      @dsporder_28 INT =NULL,
      @mobileshowtype_29 INT =NULL ,
      @flag INT OUTPUT ,
      @msg VARCHAR(60) OUTPUT      
    )
AS 
    INSERT  INTO HrmResource
            ( id ,
              workcode ,
              lastname ,
              sex ,
              resourceimageid ,
              departmentid ,
              costcenterid ,
              jobtitle ,
              joblevel ,
              jobactivitydesc ,
              managerid ,
              assistantid ,
              status ,
              locationid ,
              workroom ,
              telephone ,
              mobile ,
              mobilecall ,
              fax ,
              jobcall ,
              seclevel ,
              subcompanyid1 ,
              managerstr ,
              accounttype ,
              belongto ,
              systemlanguage ,
              email ,
              dsporder,
              mobileshowtype          
            )
    VALUES  ( @id_1 ,
              @workcode_2 ,
              @lastname_3 ,
              @sex_5 ,
              @resoureimageid_6 ,
              @departmentid_7 ,
              @costcenterid_8 ,
              @jobtitle_9 ,
              @joblevel_10 ,
              @jobactivitydesc_11 ,
              @managerid_12 ,
              @assistantid_13 ,
              @status_14 ,
              @locationid_15 ,
              @workroom_16 ,
              @telephone_17 ,
              @mobile_18 ,
              @mobilecall_19 ,
              @fax_20 ,
              @jobcall_21 ,
              0 ,
              @subcompanyid1_22 ,
              @managerstr_23 ,
              @accounttype_24 ,
              @belongto_25 ,
              @systemlanguage_26 ,
              @email_27 ,
              @dsporder_28,
              @mobileshowtype_29            
            )
GO            
            ALTER PROCEDURE HrmResourceBasicInfo_Update
    (
      @id_1 INT ,
      @workcode_2 VARCHAR(60) ,
      @lastname_3 VARCHAR(60) ,
      @sex_5 CHAR(1) ,
      @resoureimageid_6 INT ,
      @departmentid_7 INT ,
      @costcenterid_8 INT ,
      @jobtitle_9 INT ,
      @joblevel_10 INT ,
      @jobactivitydesc_11 VARCHAR(200) ,
      @managerid_12 INT ,
      @assistantid_13 INT ,
      @status_14 CHAR(1) ,
      @locationid_15 INT ,
      @workroom_16 VARCHAR(60) ,
      @telephone_17 VARCHAR(60) ,
      @mobile_18 VARCHAR(60) ,
      @mobilecall_19 VARCHAR(30) ,
      @fax_20 VARCHAR(60) ,
      @jobcall_21 INT ,
      @systemlanguage_22 INT ,
      @accounttype_23 INT ,
      @belongto_24 INT ,
      @email_25 VARCHAR(60)=NULL ,
      @dsporder_26 FLOAT =NULL,
      @mobileshowtype_27 int =NULL,
      @flag INT OUTPUT ,
      @msg VARCHAR(60) OUTPUT 
    )
AS 
    UPDATE  HrmResource
    SET     workcode = @workcode_2 ,
            lastname = @lastname_3 ,
            sex = @sex_5 ,
            resourceimageid = @resoureimageid_6 ,
            departmentid = @departmentid_7 ,
            costcenterid = @costcenterid_8 ,
            jobtitle = @jobtitle_9 ,
            joblevel = @joblevel_10 ,
            jobactivitydesc = @jobactivitydesc_11 ,
            managerid = @managerid_12 ,
            assistantid = @assistantid_13 ,
            status = @status_14 ,
            locationid = @locationid_15 ,
            workroom = @workroom_16 ,
            telephone = @telephone_17 ,
            mobile = @mobile_18 ,
            mobilecall = @mobilecall_19 ,
            fax = @fax_20 ,
            jobcall = @jobcall_21 ,
            systemlanguage = @systemlanguage_22 ,
            accounttype = @accounttype_23 ,
            belongto = @belongto_24,
            email = @email_25,
		    dsporder = @dsporder_26,
		    mobileshowtype = @mobileshowtype_27
    WHERE   id = @id_1
    UPDATE  CRM_CustomerInfo
    SET     department = @departmentid_7
    WHERE   manager = @id_1 
GO    
ALTER TABLE HrmTrainPlanRange
ADD seclevel_to INT
GO
UPDATE HrmTrainPlanRange SET seclevel_to = 100
GO
UPDATE SystemLogItem SET typeid = 1 WHERE itemid IN(1,2,3,4,5,6,9,75,100)
GO
UPDATE SystemLogItem SET typeid = 2
WHERE itemid IN(10,11,12,13,14,15,16,17,21,
23,24,25,26,27,28,29,32,33,
34,58,59,7,8,66,67,69,70,
79,80,81,82,83,65,68,63,89,
93,94,64,96,97,101,102,103,
105,110)
GO
UPDATE SystemLogItem SET typeid = 3 WHERE itemid IN(39,40,45,46)
GO
UPDATE SystemLogItem SET typeid = 4 
WHERE itemid IN(18,19,20,30,31,35,
36,37,38,42,48,78)
GO
UPDATE SystemLogItem SET typeid = 5 
WHERE itemid IN(43,44,47,49,50,51,
52,53,54,55,56)
GO
UPDATE SystemLogItem SET typeid = 6
WHERE itemid IN(57)
GO
UPDATE SystemLogItem SET typeid = 7
WHERE itemid IN(85,86,87,88)
GO
UPDATE SystemLogItem SET typeid = 8
WHERE itemid IN(90)
GO
UPDATE SystemLogItem SET typeid = 9
WHERE itemid IN(91)
GO
UPDATE SystemLogItem SET typeid = 10
WHERE itemid IN(95)
GO
UPDATE SystemLogItem SET typeid = 11
WHERE itemid IN(99,106,107,108,109,
143,144,145,146)
GO
UPDATE SystemLogItem SET typeid = NULL WHERE itemid = 60
GO
UPDATE SystemLogItem SET typeid = NULL WHERE typeid NOT IN( 7,1,2,11,10,5,4,8)
GO
create table SystemLogItemType(
typeid int PRIMARY KEY,
labelid INT
)
GO
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(1,33260)
GO
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(2,179)
GO
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(4,33274)
GO
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(5,33263)
GO
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(7,33259)
GO
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(8,33264)
GO
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(10,33262)
GO
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(11,33261)
GO
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(-1,20824)
GO