ALTER TABLE SystemSet ADD hrmdetachable INTEGER
/
ALTER TABLE SystemSet ADD hrmdftsubcomid INTEGER
/
ALTER TABLE SystemSet ADD wfdetachable INTEGER
/
ALTER TABLE SystemSet ADD wfdftsubcomid INTEGER
/
ALTER TABLE SystemSet ADD docdetachable INTEGER
/
ALTER TABLE SystemSet ADD docdftsubcomid INTEGER
/
ALTER TABLE SystemSet ADD portaldetachable INTEGER
/
ALTER TABLE SystemSet ADD portaldftsubcomid INTEGER
/
ALTER TABLE SystemSet ADD cptdetachable INTEGER
/
ALTER TABLE SystemSet ADD cptdftsubcomid INTEGER
/
ALTER TABLE SystemSet ADD mtidetachable INTEGER
/
ALTER TABLE SystemSet ADD mtidftsubcomid INTEGER
/
ALTER TABLE SystemSet ADD wcdetachable INTEGER
/
ALTER TABLE SystemSet ADD wcdftsubcomid INTEGER
/
ALTER TABLE hrmresourcemanager ADD subcompanyids varchar2(4000)
/
ALTER TABLE SysDetachDetail DROP COLUMN "type"
/
ALTER TABLE SysDetachDetail ADD type1 INTEGER
/
alter table SysDetachDetail rename column type1 to "type"
/
CREATE OR REPLACE PROCEDURE SystemDMSet_Update(detachable_1  char,
                                               dftsubcomid_2 integer,
                                               hrmdetachable_3  char,
                                               hrmdftsubcomid_4 integer,   
                                               wfdetachable_5  char,
                                               wfdftsubcomid_6 integer,   
                                               docdetachable_7  char,
                                               docdftsubcomid_8 integer,      
                                               portaldetachable_9  char,
                                               portaldftsubcomid_10 integer,                                                  
                                               cptdetachable_11  char,
                                               cptdftsubcomid_12 integer,                                                  
                                               mtidetachable_13  char,
                                               mtidftsubcomid_14 integer,                                                                                                                                            
                                               flag          out integer,
                                               msg           out varchar2,
                                               thecursor     IN OUT cursor_define.weavercursor) AS
begin
  update SystemSet
     set detachable = detachable_1, 
     dftsubcomid = dftsubcomid_2,
     hrmdetachable = hrmdetachable_3, 
     hrmdftsubcomid = hrmdftsubcomid_4,     
     wfdetachable = wfdetachable_5, 
     wfdftsubcomid = wfdftsubcomid_6,  
     docdetachable = docdetachable_7, 
     docdftsubcomid = docdftsubcomid_8,  
     portaldetachable = portaldetachable_9, 
     portaldftsubcomid = portaldftsubcomid_10,  
     cptdetachable = cptdetachable_11, 
     cptdftsubcomid = cptdftsubcomid_12,  
     mtidetachable = mtidetachable_13, 
     mtidftsubcomid = mtidftsubcomid_14;
end;
/
CREATE OR REPLACE PROCEDURE SystemSet_DftSCUpdate(dftsubcomid_1 integer,
                                                  hrmdftsubcomid_2 integer,
                                                  wfdftsubcomid_3 integer,
                                                  docdftsubcomid_4 integer,
                                                  portaldftsubcomid_5 integer,
                                                  cptdftsubcomid_6 integer,  
                                                  mtidftsubcomid_7 integer,                                                                                                                                                                                                                                                        
                                                  flag          out integer,
                                                  msg           out varchar2,
                                                  thecursor     IN OUT cursor_define.weavercursor) AS
begin
 update HrmRoles
     set subcompanyid = hrmdftsubcomid_2
   where subcompanyid is null
      or subcompanyid = 0
      or subcompanyid = -1
      or subcompanyid not in (select id from hrmsubcompany);
      
  update HrmCareerApply
     set subCompanyId = hrmdftsubcomid_2
   where subCompanyId is null
      or subCompanyId = 0
      or subCompanyId = -1
      or subCompanyId not in (select id from hrmsubcompany);
   
  update HrmContractTemplet
     set subcompanyid = hrmdftsubcomid_2
   where subcompanyid is null
      or subcompanyid = 0
      or subcompanyid = -1
      or subcompanyid not in (select id from hrmsubcompany);
  update HrmContractType
     set subcompanyid = hrmdftsubcomid_2
   where subcompanyid is null
      or subcompanyid = 0
      or subcompanyid = -1
      or subcompanyid not in (select id from hrmsubcompany);            
      
  update workflow_formdict
     set subcompanyid = wfdftsubcomid_3
   where subcompanyid is null
      or subcompanyid = 0
      or subcompanyid = -1
      or subcompanyid not in (select id from hrmsubcompany);
  update workflow_formdictdetail
     set subcompanyid = wfdftsubcomid_3
   where subcompanyid is null
      or subcompanyid = 0
      or subcompanyid = -1
      or subcompanyid not in (select id from hrmsubcompany);
  update workflow_formbase
     set subcompanyid = wfdftsubcomid_3
   where subcompanyid is null
      or subcompanyid = 0
      or subcompanyid = -1
      or subcompanyid not in (select id from hrmsubcompany);
  update workflow_base
     set subcompanyid = wfdftsubcomid_3
   where subcompanyid is null
      or subcompanyid = 0
      or subcompanyid = -1
      or subcompanyid not in (select id from hrmsubcompany);

  update cptcapital
     set blongsubcompany = cptdftsubcomid_6
   where blongsubcompany is null
      or blongsubcompany = 0
      or blongsubcompany = -1
      or blongsubcompany not in (select id from hrmsubcompany);

  UPDATE MeetingRoom
     SET subcompanyId = mtidftsubcomid_7
   WHERE subcompanyId IS null
      OR subcompanyId = 0
      OR subcompanyId = -1
      OR subcompanyid NOT IN (SELECT id FROM hrmSubcompany);
  UPDATE Meeting_Type
     SET subcompanyId = mtidftsubcomid_7
   WHERE subcompanyId IS null
      OR subcompanyId = 0
      OR subcompanyId = -1
      OR subcompanyid NOT IN (SELECT id FROM hrmSubcompany);      
      
end;
/
create table moduleManageDetach
(
  ID                       INTEGER not null,
  manageType               CHAR(2),
  administrators           VARCHAR2(4000),
  Seclevel                 INTEGER,
  hrmSubcomids             VARCHAR2(4000),
  wfSubcomids              VARCHAR2(4000),
  docSubcomids             VARCHAR2(4000),
  portalSubcomids          VARCHAR2(4000),
  cptSubcomids             VARCHAR2(4000),
  mtiSubcomids             VARCHAR2(4000),
  created_by               INTEGER,
  created_date             VARCHAR2(20),
  updated_by               INTEGER,
  updated_date             VARCHAR2(20),
  remark                   VARCHAR2(400)
)
/
CREATE sequence moduleManageDetach_id
START WITH 1
INCREMENT BY 1
nomaxvalue
nocycle
/
CREATE OR REPLACE TRIGGER moduleManageDetach_Tri
before INSERT ON moduleManageDetach
FOR each ROW
BEGIN
SELECT moduleManageDetach_id.NEXTVAL INTO :NEW.id FROM dual;
END;
/
create table effectManageEmpower
(
  ID                       INTEGER not null,
  manageType               CHAR(2),
  administrators           VARCHAR2(4000),
  Seclevel                 INTEGER,
  workflowTypes            VARCHAR2(4000),
  docmaincategorys         VARCHAR2(4000),
  portalTypes              VARCHAR2(4000),
  coworkTypes              VARCHAR2(4000),
  created_by               INTEGER,
  created_date             VARCHAR2(20),
  updated_by               INTEGER,
  updated_date             VARCHAR2(20),
  remark                   VARCHAR2(400)
)
/
CREATE sequence effectManageEmpower_id
START WITH 1
INCREMENT BY 1
nomaxvalue
nocycle
/
CREATE OR REPLACE TRIGGER effectManageEmpower_Tri
before INSERT ON effectManageEmpower
FOR each ROW
BEGIN
SELECT effectManageEmpower_id.NEXTVAL INTO :NEW.id FROM dual;
END;
/
create table hrmroles_module
(
  ID           INTEGER not null,
  ROLESMARK    VARCHAR2(60),
  ROLESNAME    VARCHAR2(200),
  DOCID        INTEGER,
  ISDEFAULT    CHAR(1),
  TYPE         INTEGER,
  SUBCOMPANYID INTEGER
)
/
create table wfAccessControlList
(
  mainid                   INTEGER not null,
  dirid                    INTEGER not null,
  dirtype                  INTEGER,
  seclevel                 INTEGER,
  departmentid             INTEGER,
  roleid                   INTEGER,
  rolelevel                INTEGER,
  usertype                 INTEGER,
  permissiontype           INTEGER not null,
  operationcode            INTEGER,
  userid                   INTEGER,
  DocSecCategoryTemplateId INTEGER,
  subcompanyid             INTEGER
)
/
CREATE sequence wfAccessControlList_MAINID
START WITH 1
INCREMENT BY 1
nomaxvalue
nocycle
/
CREATE OR REPLACE TRIGGER wfAccessControlList_Tri
before INSERT ON wfAccessControlList
FOR each ROW
BEGIN
SELECT wfAccessControlList_MAINID.NEXTVAL INTO :NEW.MAINID FROM dual;
END;
/
create table ptAccessControlList
(
  mainid                   INTEGER not null,
  dirid                    INTEGER not null,
  dirtype                  INTEGER,
  seclevel                 INTEGER,
  departmentid             INTEGER,
  roleid                   INTEGER,
  rolelevel                INTEGER,
  usertype                 INTEGER,
  permissiontype           INTEGER not null,
  operationcode            INTEGER,
  userid                   INTEGER,
  DocSecCategoryTemplateId INTEGER,
  subcompanyid             INTEGER
)
/
CREATE sequence ptAccessControlList_MAINID
START WITH 1
INCREMENT BY 1
nomaxvalue
nocycle
/
CREATE OR REPLACE TRIGGER ptAccessControlList_Tri
before INSERT ON ptAccessControlList
FOR each ROW
BEGIN
SELECT ptAccessControlList_MAINID.NEXTVAL INTO :NEW.MAINID FROM dual;
END;
/
create table cwAccessControlList
(
  mainid                   INTEGER not null,
  dirid                    INTEGER not null,
  dirtype                  INTEGER,
  seclevel                 INTEGER,
  departmentid             INTEGER,
  roleid                   INTEGER,
  rolelevel                INTEGER,
  usertype                 INTEGER,
  permissiontype           INTEGER not null,
  operationcode            INTEGER,
  userid                   INTEGER,
  DocSecCategoryTemplateId INTEGER,
  subcompanyid             INTEGER
)
/
CREATE sequence cwAccessControlList_MAINID
START WITH 1
INCREMENT BY 1
nomaxvalue
nocycle
/
CREATE OR REPLACE TRIGGER cwAccessControlList_Tri
before INSERT ON cwAccessControlList
FOR each ROW
BEGIN
SELECT cwAccessControlList_MAINID.NEXTVAL INTO :NEW.MAINID FROM dual;
END;
/
ALTER table SysDetachDetail add operator char(2)
/
ALTER table SysDetachDetail add rolelevel char(1)
/
alter table HrmGroup add sn number(5,2) default 0
/
update HrmGroup set sn = 0
/
CREATE TABLE Hrm_Rp_Sub_Template(
	id number primary key,
	name varchar2(50) NOT NULL,
	author number NOT NULL,
	create_date timestamp NOT NULL,
	scope varchar2(50) NOT NULL,
	delflag number NOT NULL
)
/
create sequence Hrm_Rp_Sub_Template_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
CREATE OR REPLACE TRIGGER Hrm_Rp_Sub_Template_Trigger before insert on Hrm_Rp_Sub_Template for each row begin select Hrm_Rp_Sub_Template_id.nextval into :new.id from dual; end;
/
CREATE TABLE hrm_rp_sub_template_con(
	id number PRIMARY KEY,
	template_id number NOT NULL,
	col_name varchar2(50) NULL,
	con_htmltype varchar2(50) NULL,
	con_type varchar2(50) NULL,
	con_opt varchar2(50) NULL,
	con_value varchar2(50) NULL,
	con_opt1 varchar2(50) NULL,
	con_value1 varchar2(50) NULL
)
/
create sequence hrm_rp_sub_tep_con_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
CREATE OR REPLACE TRIGGER hrm_rp_sub_tep_con_Trigger before insert on hrm_rp_sub_template_con for each row begin select hrm_rp_sub_tmp_con_id.nextval into :new.id from dual; end;
/
alter table HrmRpSubDefine modify(scopeid varchar2(50))
/
alter table HrmRpSubDefine modify(colname varchar2(50))
/
alter table HrmRpSubDefine add templateid number default 0
/
update HrmRpSubDefine set templateid = 0
/
alter table HrmRpSubDefine modify(showorder number(5,2))
/
alter table HrmCheckPost add deptid number default 0
/
alter table HrmCheckPost add subcid number default 0
/
update HrmCheckPost set deptid=0, subcid=0
/
ALTER TABLE cus_formfield
ADD isuse CHAR(1)
/
update cus_formfield set  isuse='1' where scope='ProjCustomField' and isuse is null
/
ALTER TABLE HrmListValidate
ADD parentid INT
/
ALTER TABLE HrmListValidate
ADD TAB_url VARCHAR(500)
/
ALTER TABLE HrmListValidate
ADD tab_type INT
/
ALTER TABLE HrmListValidate
ADD tab_index INT
/
UPDATE HrmListValidate SET parentid =29 WHERE id IN(24,26,27,28)
/
UPDATE HrmListValidate SET parentid =36 WHERE id IN(36,37,38,39)
/
UPDATE HrmListValidate SET tab_type=2 WHERE tab_url IS NOT null
/
ALTER TABLE HrmArrangeShiftSet
ADD arrangeShiftType INT
/
ALTER TABLE HrmArrangeShiftSet
ADD relatedId INT
/
ALTER TABLE HrmArrangeShiftSet
ADD levelfrom INT
/
ALTER TABLE HrmArrangeShiftSet
ADD levelto INT
/
ALTER TABLE hrmkqsystemSet
ADD needsign INT
/
ALTER TABLE hrmkqsystemSet 
ADD onlyworkday INT
/
ALTER TABLE hrmkqsystemSet 
ADD signTimeScope VARCHAR(500)
/
ALTER TABLE hrmresource
ADD mobileshowtype INT
/
CREATE TABLE TmpOnlineUserId (id INT PRIMARY KEY)
/
ALTER TABLE subcompanyDefineField 
ADD ismand CHAR(1)
/
ALTER TABLE departmentDefineField 
ADD ismand CHAR(1)
/
INSERT INTO HrmListValidate(id, name, validate_n, tab_index,tab_type) VALUES(29,'工作历程',1,2,1)
/
INSERT INTO HrmListValidate(id, name, validate_n, tab_index,tab_type) VALUES(30,'快捷功能',1,99,1)
/
INSERT INTO HrmListValidate(id, name, validate_n, tab_index,tab_type, parentid) VALUES(31,'发送短信',1,1,1,30)
/
INSERT INTO HrmListValidate(id, name, validate_n, tab_index,tab_type, parentid) VALUES(32,'新建日程',1,2,1,30)
/
INSERT INTO HrmListValidate(id, name, validate_n, tab_index,tab_type, parentid) VALUES(33,'新建协作',1,3,1,30)
/
UPDATE HrmListValidate SET tab_type=1 WHERE id<29
/
UPDATE HrmListValidate SET tab_index =1 WHERE id=3
/
UPDATE HrmListValidate SET tab_index =3 WHERE id=11
/
UPDATE HrmListValidate SET tab_index =4 WHERE id=12
/
UPDATE HrmListValidate SET tab_index =6 WHERE id=13
/
UPDATE HrmListValidate SET tab_index =7 WHERE id=14
/
UPDATE HrmListValidate SET tab_index =5 WHERE id=15
/
UPDATE HrmListValidate SET tab_index =8 WHERE id=17
/
UPDATE HrmListValidate SET tab_index =9 WHERE id=18
/
UPDATE HrmListValidate SET tab_index =1, parentid=30 WHERE id=19
/
UPDATE HrmListValidate SET tab_index =11 WHERE id=20
/
UPDATE HrmListValidate SET tab_index =12 WHERE id=21
/
UPDATE HrmListValidate SET tab_index =13 WHERE id=22
/
UPDATE HrmListValidate SET tab_index =10 WHERE id=23
/
UPDATE HrmListValidate SET parentid=29 WHERE id=24
/
UPDATE HrmListValidate SET parentid=29 WHERE id=26
/
UPDATE HrmListValidate SET parentid=29 WHERE id=27
/
UPDATE HrmListValidate SET parentid=29 WHERE id=28
/
UPDATE HrmListValidate SET tab_index=99 WHERE tab_index IS NULL
/
Delete from MainMenuInfo where id=1339
/
CREATE TABLE HrmBirthdayShare(
	id int  NOT NULL,
	sharetype int NULL,
	seclevel int NULL,
	rolelevel int NULL,
	sharelevel int NULL,
	userid int NULL,
	subcompanyid int NULL,
	departmentid int NULL,
	roleid int NULL,
	foralluser int NULL
	)
/
create sequence HrmBirthdayShare_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
CREATE OR REPLACE TRIGGER HrmBirthdayShare_Trigger before insert on HrmBirthdayShare for each row begin select HrmBirthdayShare_ID.nextval into :new.id from dual; end;
/
CREATE OR REPLACE PROCEDURE HrmBirthdayShare_Insert
    (
      sharetype_1 INT ,
      seclevel_1 INT ,
      rolelevel_1 INT ,
      sharelevel_1 INT ,
      userid_1 INT ,
      subcompanyid_1 INT ,
      departmentid_1 INT ,
      roleid_1 INT ,
      foralluser_1 INT 
    )as
begin
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
              sharetype_1 ,
              seclevel_1 ,
              rolelevel_1 ,
              sharelevel_1 ,
              userid_1 ,
              subcompanyid_1 ,
              departmentid_1 ,
              roleid_1 ,
              foralluser_1
            );
            end;
/
CREATE OR REPLACE PROCEDURE HrmBirthdayShare_Delete
    (
      id1 INT
    )
AS
begin
    DELETE  FROM HrmBirthdayShare
    WHERE   id = id1  ;
end;
/    

alter table HrmTrainDay
add starttime char(5)
/
alter table HrmTrainDay
add endtime char(5)
/
CREATE OR REPLACE PROCEDURE HrmTrainDay_Insert(trainid_1 integer,
                                               day_2     char,
                                               content_3 varchar2,
                                               aim_4     varchar2,
                                               flag      out integer,
                                               msg       out varchar2,
                                               thecursor IN OUT cursor_define.weavercursor) as
begin
  insert into HrmTrainDay
    (trainid, traindate, daytraincontent, daytrainaim)
  values
    (trainid_1, day_2, content_3, aim_4);
  open thecursor for
    select max(id) from HrmTrainDay;
end;
/
CREATE OR REPLACE PROCEDURE HrmTrainDay_Update(day_1     char,
                                               content_2 varchar2,
                                               aim_3     varchar2,
                                               effect_4  varchar2,
                                               plain_5   varchar2,
                                               id_6      integer,
                                               flag      out integer,
                                               msg       out varchar2,
                                               thecursor IN OUT cursor_define.weavercursor) as
begin
  update HrmTrainDay
     set traindate       = day_1,
         daytraincontent = content_2,
         daytrainaim     = aim_3,
         daytraineffect  = effect_4,
         daytrainplain   = plain_5
   where id = id_6;
end;
/

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
/

DELETE FROM HrmListValidate WHERE name  IN ('日志','密码')
/
CREATE OR REPLACE PROCEDURE HrmResourceContactInfo_Update(id_1              integer,
                                                          locationid_15     integer,
                                                          workroom_16       varchar2,
                                                          telephone_17      varchar2,
                                                          mobile_18         varchar2,
                                                          mobilecall_19     varchar2,
                                                          fax_20            varchar2,
                                                          systemlanguage_21 integer,
                                                          email_22          varchar2,
                                                          flag              out integer,
                                                          msg               out varchar2,
                                                          thecursor         IN OUT cursor_define.weavercursor) AS
begin
  UPDATE HrmResource
     SET locationid     = locationid_15,
         workroom       = workroom_16,
         telephone      = telephone_17,
         mobile         = mobile_18,
         mobilecall     = mobilecall_19,
         fax            = fax_20,
         email          = email_22,
         systemlanguage = systemlanguage_21
   WHERE id = id_1;
end;
/
INSERT INTO HrmListValidate (id, name,validate_n,parentid,TAB_url,tab_type,tab_index)
values (35,'当前考核',1,29,NULL,1,100)
/
UPDATE HrmListValidate SET name = '工资福利' WHERE name='财务信息'
/
UPDATE HrmListValidate SET name = '待办事宜' WHERE name='工作流'
/
UPDATE HrmListValidate SET name = '日程安排' WHERE name='计划'
/
UPDATE HrmListValidate SET name = '考勤情况' WHERE name='考勤'
/
UPDATE HrmListValidate SET name = '奖惩考核' WHERE name='奖惩记录'
/
UPDATE HrmListValidate SET name = '发送邮件' WHERE name='邮件发送'
/
ALTER TABLE SystemLogItem ADD typeid INT
/
delete from SystemLogItem where itemid='301'
/
insert into SystemLogItem values('301',30041,'文档',1)
/
INSERT INTO SystemLogItem (itemid, lableid, itemdesc,typeid) 
VALUES (166,32744,'自定义显示栏目',179)
/
UPDATE HrmListValidate SET name='考勤情况' WHERE name = '考勤管理'
/
UPDATE HrmListValidate SET name='培训记录' WHERE name = '培训管理'
/
ALTER TABLE HrmResource ADD usbstate int 
/
CREATE OR REPLACE PROCEDURE HrmResourceContactInfo_Update(id_1              integer,
                                                          locationid_15     integer,
                                                          workroom_16       varchar2,
                                                          telephone_17      varchar2,
                                                          mobile_18         varchar2,
                                                          mobilecall_19     varchar2,
                                                          fax_20            varchar2,
                                                          systemlanguage_21 integer,
                                                          email_22          varchar2,
                                                          flag              out integer,
                                                          msg               out varchar2,
                                                          thecursor         IN OUT cursor_define.weavercursor) AS
begin
  UPDATE HrmResource
     SET locationid     = locationid_15,
         workroom       = workroom_16,
         telephone      = telephone_17,
         mobile         = mobile_18,
         mobilecall     = mobilecall_19,
         fax            = fax_20,
         email          = email_22,
         systemlanguage = systemlanguage_21
   WHERE id = id_1;
end;
  /
   CREATE OR REPLACE PROCEDURE HrmResourceBasicInfo_Insert(id_1               integer,
                                                        workcode_2         varchar2,
                                                        lastname_3         varchar2,
                                                        sex_5              char,
                                                        resoureimageid_6   integer,
                                                        departmentid_7     integer,
                                                        costcenterid_8     integer,
                                                        jobtitle_9         integer,
                                                        joblevel_10        integer,
                                                        jobactivitydesc_11 varchar2,
                                                        managerid_12       integer,
                                                        assistantid_13     integer,
                                                        status_14          char,
                                                        locationid_15      integer,
                                                        workroom_16        varchar2,
                                                        telephone_17       varchar2,
                                                        mobile_18          varchar2,
                                                        mobilecall_19      varchar2,
                                                        fax_20             varchar2,
                                                        jobcall_21         integer,
                                                        subcompanyid1_22   integer,
                                                        managerstr_23      varchar2,
                                                        accounttype_24     integer,
                                                        belongto_25        integer,
                                                        systemlanguage_26  integer,
                                                        email_27           VARCHAR2,
                                                        dsporder_28        INT,
                                                        mobileshowtype_29  INT,
                                                        flag               out integer,
                                                        msg                out varchar2,
                                                        thecursor          IN OUT cursor_define.weavercursor) AS
BEGIN
  INSERT INTO HrmResource
    (id,
     workcode,
     lastname,
     sex,
     resourceimageid,
     departmentid,
     costcenterid,
     jobtitle,
     joblevel,
     jobactivitydesc,
     managerid,
     assistantid,
     status,
     locationid,
     workroom,
     telephone,
     mobile,
     mobilecall,
     fax,
     jobcall,
     seclevel,
     subcompanyid1,
     managerstr,
     dsporder,
     accounttype,
     belongto,
     systemlanguage,
     email,
     mobileshowtype)
  VALUES
    (id_1,
     workcode_2,
     lastname_3,
     sex_5,
     resoureimageid_6,
     departmentid_7,
     costcenterid_8,
     jobtitle_9,
     joblevel_10,
     jobactivitydesc_11,
     managerid_12,
     assistantid_13,
     status_14,
     locationid_15,
     workroom_16,
     telephone_17,
     mobile_18,
     mobilecall_19,
     fax_20,
     jobcall_21,
     0,
     subcompanyid1_22,
     managerstr_23,
     dsporder_28,
     accounttype_24,
     belongto_25,
     systemlanguage_26,
     email_27,
     mobileshowtype_29);
end;
/            
            
CREATE OR REPLACE PROCEDURE HrmResourceBasicInfo_Update(id_1               integer,
                                                        workcode_2         varchar2,
                                                        lastname_3         varchar2,
                                                        sex_5              char,
                                                        resoureimageid_6   integer,
                                                        departmentid_7     integer,
                                                        costcenterid_8     integer,
                                                        jobtitle_9         integer,
                                                        joblevel_10        integer,
                                                        jobactivitydesc_11 varchar2,
                                                        managerid_12       integer,
                                                        assistantid_13     integer,
                                                        status_14          char,
                                                        locationid_15      integer,
                                                        workroom_16        varchar2,
                                                        telephone_17       varchar2,
                                                        mobile_18          varchar2,
                                                        mobilecall_19      varchar2,
                                                        fax_20             varchar2,
                                                        jobcall_21         integer,
                                                        systemlanguage_22  integer,
                                                        accounttype_23     integer,
                                                        belongto_24        integer,
                                                        email_25           VARCHAR,
                                                        dsporder_26        FLOAT,
                                                        mobileshowtype_27  INT,
                                                        flag               out integer,
                                                        msg                out varchar2,
                                                        thecursor          IN OUT cursor_define.weavercursor) AS
begin
  UPDATE HrmResource_Trigger
     SET departmentid = departmentid_7, managerid = managerid_12
   WHERE id = id_1;
  UPDATE HrmResource
     SET workcode        = workcode_2,
         lastname        = lastname_3,
         sex             = sex_5,
         resourceimageid = resoureimageid_6,
         departmentid    = departmentid_7,
         costcenterid    = costcenterid_8,
         jobtitle        = jobtitle_9,
         joblevel        = joblevel_10,
         jobactivitydesc = jobactivitydesc_11,
         managerid       = managerid_12,
         assistantid     = assistantid_13,
         status          = status_14,
         locationid      = locationid_15,
         workroom        = workroom_16,
         telephone       = telephone_17,
         mobile          = mobile_18,
         mobilecall      = mobilecall_19,
         fax             = fax_20,
         jobcall         = jobcall_21,
         systemlanguage  = systemlanguage_22,
         accounttype     = accounttype_23,
         belongto        = belongto_24,
         email           = email_25,
         dsporder        = dsporder_26,
         mobileshowtype  = mobileshowtype_27
   WHERE id = id_1;
  UPDATE CRM_CustomerInfo
     SET department = departmentid_7
   WHERE manager = id_1;
end;
/    
ALTER TABLE HrmTrainPlanRange
ADD seclevel_to INT
/
UPDATE HrmTrainPlanRange SET seclevel_to = 100
/
UPDATE SystemLogItem SET typeid = 1 WHERE itemid IN(1,2,3,4,5,6,9,75,100)
/
UPDATE SystemLogItem SET typeid = 2
WHERE itemid IN(10,11,12,13,14,15,16,17,21,
23,24,25,26,27,28,29,32,33,
34,58,59,7,8,66,67,69,70,
79,80,81,82,83,65,68,63,89,
93,94,64,96,97,101,102,103,
105,110)
/
UPDATE SystemLogItem SET typeid = 3 WHERE itemid IN(39,40,45,46)
/
UPDATE SystemLogItem SET typeid = 4 
WHERE itemid IN(18,19,20,30,31,35,
36,37,38,42,48,78)
/
UPDATE SystemLogItem SET typeid = 5 
WHERE itemid IN(43,44,47,49,50,51,
52,53,54,55,56)
/
UPDATE SystemLogItem SET typeid = 6
WHERE itemid IN(57)
/
UPDATE SystemLogItem SET typeid = 7
WHERE itemid IN(85,86,87,88)
/
UPDATE SystemLogItem SET typeid = 8
WHERE itemid IN(90)
/
UPDATE SystemLogItem SET typeid = 9
WHERE itemid IN(91)
/
UPDATE SystemLogItem SET typeid = 10
WHERE itemid IN(95)
/
UPDATE SystemLogItem SET typeid = 11
WHERE itemid IN(99,106,107,108,109,
143,144,145,146)
/
UPDATE SystemLogItem SET typeid = NULL WHERE itemid = 60
/
UPDATE SystemLogItem SET typeid = NULL WHERE typeid NOT IN( 7,1,2,11,10,5,4,8)
/
create table SystemLogItemType(
typeid int PRIMARY KEY,
labelid INT
)
/
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(1,33260)
/
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(2,179)
/
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(4,33274)
/
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(5,33263)
/
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(7,33259)
/
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(8,33264)
/
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(10,33262)
/
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(11,33261)
/
INSERT INTO SystemLogItemType (typeid, labelid) VALUES(-1,20824)
/