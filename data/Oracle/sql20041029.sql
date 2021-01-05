CREATE GLOBAL TEMPORARY TABLE TmpTableValueWP
 (
 workPlanId integer, shareLevel integer)
 ON COMMIT DELETE ROWS
/


/* table */
ALTER TABLE WorkPlan ADD urgentLevel char(1) DEFAULT '1'
/

ALTER TABLE WorkPlan ADD agentId integer DEFAULT 0
/

ALTER TABLE WorkPlan ADD deptId integer NULL
/

ALTER TABLE WorkPlan ADD subcompanyId integer NULL
/

ALTER TABLE WorkPlan add  name_n varchar2(200)
/
update WorkPlan set name_n = name 
/
ALTER TABLE WorkPlan drop column name 
/
ALTER TABLE WorkPlan add  name varchar2(200)
/
update WorkPlan set name  = name_n 
/
ALTER TABLE WorkPlan  drop column name_n 
/

ALTER TABLE Prj_TaskProcess ADD realManDays number(6, 1) NULL
/

ALTER TABLE Prj_TaskModifyLog ADD realManDays number(6, 1) NULL
/

CREATE TABLE WorkPlanViewLog (
id integer  NOT NULL,
workPlanId integer NULL,
viewType char(1) NULL,
userId integer NULL,
userType char (1) NULL,
ipAddress char (15) NULL,
logDate char (10) NULL,
logTime char (8) NULL,
PRIMARY KEY(id)
)
/
create sequence WorkPlanViewLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WorkPlanViewLog_Trigger
before insert on WorkPlanViewLog
for each row
begin
select WorkPlanViewLog_id.nextval into :new.id from dual;
end;
/

CREATE TABLE WorkPlanEditLog (
id integer  NOT NULL,
workPlanId integer NULL,
fieldName varchar2 (30) NULL,
oldValue varchar2 (100) NULL,
newValue varchar2 (100) NULL,
userId integer NULL,
userType char (1) NULL,
ipAddress char (15) NULL,
logDate char (10) NULL,
logTime char (8) NULL,
PRIMARY KEY(id)
)
/
create sequence WorkPlanEditLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WorkPlanEditLog_Trigger
before insert on WorkPlanEditLog
for each row
begin
select WorkPlanEditLog_id.nextval into :new.id from dual;
end;
/

CREATE TABLE WorkPlanExchange (
id integer  NOT NULL,
workPlanId integer NULL,
memberId integer NULL,
exchangeCount integer DEFAULT 0,
PRIMARY KEY(id)
)
/

create sequence WorkPlanExchange_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WorkPlanExchange_Trigger
before insert on WorkPlanExchange
for each row
begin
select WorkPlanExchange_id.nextval into :new.id from dual;
end;
/

CREATE TABLE WorkPlanShare (
id int NOT NULL,
workPlanId integer NULL,
shareType char (1) NULL,
userId integer NULL,
deptId integer NULL,
roleId integer NULL,
forAll char(1) NULL,
roleLevel char (1) NULL,
securityLevel smallint NULL,
shareLevel char (1) NULL,
PRIMARY KEY(id)
)
/
create sequence WorkPlanShare_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WorkPlanShare_Trigger
before insert on WorkPlanShare
for each row
begin
select WorkPlanShare_id.nextval into :new.id from dual;
end;
/

CREATE TABLE WorkPlanValuate (
id integer  NOT NULL,
workPlanId integer NULL,
memberId integer NULL,
createrScore char (1) NULL,
createrId integer NULL,
managerScore char (1) NULL,
managerId integer NULL,
valCreaterDate char (10) NULL,
valManagerDate char (10) NULL,
PRIMARY KEY(id)
)
/
create sequence WorkPlanValuate_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WorkPlanValuate_Trigger
before insert on WorkPlanValuate
for each row
begin
select WorkPlanValuate_id.nextval into :new.id from dual;
end;
/

CREATE TABLE WorkPlanSetup (
userId integer NOT NULL,
reportType char (1) NOT NULL,
recCount integer NULL,
PRIMARY KEY(userId, reportType)
)
/

CREATE TABLE WorkPlanUpdate (
hasUpdated char(1) DEFAULT '0'
)
/

CREATE TABLE Prj_ViewedLog (
projId integer NOT NULL,
userId integer NOT NULL,
userType char(1) NOT NULL,
PRIMARY KEY(projId, userId, userType)
)
/

INSERT INTO WorkPlanUpdate (hasUpdated) VALUES ('0')
/


/* label */
UPDATE HtmlLabelIndex SET indexdesc = '工作计划' WHERE id = 16652
/
UPDATE HtmlLabelInfo SET labelname = '工作计划' WHERE indexid = 16652 AND languageid = 7
/

INSERT INTO HtmlLabelIndex values(17478,'计划提醒') 
/
INSERT INTO HtmlLabelInfo VALUES(17478,'计划提醒',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17478,'Work Plan Reminder',8) 
/

INSERT INTO HtmlLabelIndex values(17480,'查看日志') 
/
INSERT INTO HtmlLabelInfo VALUES(17480,'查看日志',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17480,'View Log',8) 
/

INSERT INTO HtmlLabelIndex values(17481,'更改日志') 
/
INSERT INTO HtmlLabelInfo VALUES(17481,'更改日志',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17481,'Edit Log',8) 
/

INSERT INTO HtmlLabelIndex values(17482,'操作人') 
/
INSERT INTO HtmlLabelInfo VALUES(17482,'操作人',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17482,'Operator',8) 
/

INSERT INTO HtmlLabelIndex values(17483,'查看类型') 
/
INSERT INTO HtmlLabelInfo VALUES(17483,'查看类型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17483,'View Type',8) 
/

INSERT INTO HtmlLabelIndex values(17484,'客户端地址') 
/
INSERT INTO HtmlLabelInfo VALUES(17484,'客户端地址',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17484,'Remote Address',8) 
/

INSERT INTO HtmlLabelIndex values(17485,'修改前的值') 
/
INSERT INTO HtmlLabelInfo VALUES(17485,'修改前的值',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17485,'Old Value',8) 
/

INSERT INTO HtmlLabelIndex values(17486,'修改后的值') 
/
INSERT INTO HtmlLabelInfo VALUES(17486,'修改后的值',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17486,'New Value',8) 
/

INSERT INTO HtmlLabelIndex values(17487,'个人便签') 
/
INSERT INTO HtmlLabelInfo VALUES(17487,'个人便签',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17487,'Note',8) 
/

INSERT INTO HtmlLabelIndex values(17488,'设置记录数') 
/
INSERT INTO HtmlLabelInfo VALUES(17488,'设置记录数',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17488,'Display Record Count',8) 
/

INSERT INTO HtmlLabelIndex values(17489,'提交人打分') 
/
INSERT INTO HtmlLabelInfo VALUES(17489,'提交人打分',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17489,'Creater Valuate',8) 
/

INSERT INTO HtmlLabelIndex values(17490,'上级打分') 
/
INSERT INTO HtmlLabelInfo VALUES(17490,'上级打分',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17490,'Manager Valuate',8) 
/

INSERT INTO HtmlLabelIndex values(17491,'每页显示记录数') 
/
INSERT INTO HtmlLabelInfo VALUES(17491,'每页显示记录数',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17491,'Display record count per page',8) 
/

INSERT INTO HtmlLabelIndex values(17492,'我安排的计划') 
/
INSERT INTO HtmlLabelInfo VALUES(17492,'我安排的计划',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17492,'I arrange the work plan',8) 
/
 
INSERT INTO HtmlLabelIndex values(17493,'我下属的计划') 
/
INSERT INTO HtmlLabelInfo VALUES(17493,'我下属的计划',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17493,'My underling work plan',8) 
/

INSERT INTO HtmlLabelIndex values(17494,'所有下属') 
/
INSERT INTO HtmlLabelInfo VALUES(17494,'所有下属',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17494,'All Underlings',8) 
/

INSERT INTO HtmlLabelIndex values(17495,'季度') 
/
INSERT INTO HtmlLabelInfo VALUES(17495,'季度',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17495,'Quarter',8) 
/
 
INSERT INTO HtmlLabelIndex values(17497,'到期提醒') 
/
INSERT INTO HtmlLabelInfo VALUES(17497,'到期提醒',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17497,'Work Plan Remind',8) 
/

INSERT INTO HtmlLabelIndex values(17498,'便签功能') 
/
INSERT INTO HtmlLabelInfo VALUES(17498,'便签功能',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17498,'Note Function',8) 
/

INSERT INTO HtmlLabelIndex values(17499,'更多') 
/
INSERT INTO HtmlLabelInfo VALUES(17499,'更多',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17499,'More',8) 
/
 
INSERT INTO HtmlLabelIndex values(17500,'反馈的请求') 
/
INSERT INTO HtmlLabelInfo VALUES(17500,'反馈的请求',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17500,'Feed Back Request',8) 
/
 
insert into ErrorMsgIndex (id,indexdesc) values (35,'该共享已存在！') 
/
insert into ErrorMsgInfo (indexid,msgname,languageid) values (35, '该共享已存在！', 7) 
/
insert into ErrorMsgInfo (indexid,msgname,languageid) values (35, 'This share has existed.', 8) 
/

INSERT INTO HtmlLabelIndex values(17501,'实际工时') 
/
INSERT INTO HtmlLabelInfo VALUES(17501,'实际工时',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17501,'Real Man Days',8) 
/

insert into HtmlNoteIndex (id,indexdesc) values (58,'确定要提交吗？') 
/
insert into HtmlNoteInfo (indexid,notename,languageid) values (58, '确定要提交吗？', 7) 
/
insert into HtmlNoteInfo (indexid,notename,languageid) values (58, 'Do you confirm to submit?', 8) 
/

insert into HtmlNoteIndex (id,indexdesc) values (59,'打分数据需要提交吗？') 
/

insert into HtmlNoteInfo (indexid,notename,languageid) values (59, '打分数据需要提交吗？', 7) 
/
insert into HtmlNoteInfo (indexid,notename,languageid) values (59, 'Do the score need to submit?', 
8) 
/

INSERT INTO HtmlLabelIndex values(17503,'我的考核') 
/
INSERT INTO HtmlLabelInfo VALUES(17503,'我的考核',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17503,'My Valuation',8) 
/


/* stored procedure */
CREATE or replace PROCEDURE WorkPlanViewLog_Insert (
workPlanId_1 integer, viewType_1 char, userId_1 integer, userType_1 char, ipAddress_1 char, 
logDate_1 char,
logTime_1 char, flag out  integer, msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
INSERT INTO WorkPlanViewLog (
workPlanId, viewType, userId, userType, ipAddress, logDate, logTime) VALUES (
workPlanId_1, viewType_1, userId_1, userType_1, ipAddress_1, logDate_1, logTime_1);
end;
/

CREATE or replace PROCEDURE WorkPlanEditLog_Insert (
workPlanId_1 integer, fieldName_1 varchar2, oldValue_1 varchar2, newValue_1 varchar2,
userId_1 integer, userType_1 char, ipAddress_1 char, logDate_1 char,
logTime_1 char, flag out integer  , msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
INSERT INTO WorkPlanEditLog (
workPlanId, fieldName, oldValue, newValue, userId, userType, ipAddress, logDate, logTime) VALUES (
workPlanId_1, fieldName_1, oldValue_1, newValue_1, userId_1, userType_1, ipAddress_1, 
logDate_1, logTime_1);
end;
/

CREATE or replace PROCEDURE WorkPlanShare_Ins (
workPlanId_1 integer, shareType_1 char, userId_1 integer, deptId_1 integer, roleId_1 integer, 
forAll_1 char, roleLevel_1 char, securityLevel_1 smallint, shareLevel_1 char, 
flag out integer  , msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
xx integer;
begin
SELECT count(workPlanId) into xx FROM WorkPlanShare 
WHERE workPlanId = workPlanId_1 AND shareType = shareType_1 AND userId = userId_1 
AND deptId = deptId_1 AND roleId = roleId_1 AND forAll = forAll_1 AND roleLevel = roleLevel_1 
AND securityLevel = securityLevel_1 AND shareLevel = shareLevel_1;
if xx<>0 then
open thecursor for 
SELECT -1 from dual;
ELSE
INSERT INTO WorkPlanShare (
workPlanId, shareType, userId, deptId, roleId, forAll, roleLevel, securityLevel, shareLevel) 
VALUES (
workPlanId_1, shareType_1, userId_1, deptId_1, roleId_1, forAll_1, 
roleLevel_1, securityLevel_1, shareLevel_1);
end if;
end;
/

CREATE or replace PROCEDURE WorkPlanValuate_ValCreater (
workPlanId_1 integer, memberId_1 integer, createrScore_1 char, createrId_1 integer,
valCreaterDate_1 char, flag out integer  , msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
INSERT INTO WorkPlanValuate (
workPlanId, memberId, createrScore, createrId, valCreaterDate) VALUES (
workPlanId_1, memberId_1, createrScore_1, createrId_1, valCreaterDate_1);
end;
/

CREATE or replace PROCEDURE WorkPlanValuate_ValManager (
workPlanId_1 integer, memberId_1 integer, managerScore_1 char, managerId_1 integer,
valManagerDate_1 char, flag out integer  , msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
UPDATE WorkPlanValuate SET managerScore = managerScore_1, managerId = managerId_1, 
valManagerDate = valManagerDate_1 WHERE workPlanId = workPlanId_1 AND memberId = memberId_1;
end;
/

CREATE or replace PROCEDURE WorkPlanSetup_SetRecCount (
userId_1 integer, reportType_1 char, recCount_1 integer, flag out integer  , msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
xx integer;
begin
SELECT count(userId) into xx FROM WorkPlanSetup WHERE userId = userId_1 AND reportType = 
reportType_1;
if xx<>0 then
UPDATE WorkPlanSetup SET recCount = recCount_1;
ELSE
INSERT INTO WorkPlanSetup (userId, reportType, recCount) VALUES (
userId_1, reportType_1, recCount_1);
end if;
end;
/

CREATE or replace PROCEDURE Prj_ViewedLog_Insert (
projId_1 integer, userId_1 integer, userType_1 char, flag out integer  , msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
xx integer;
begin
SELECT count(projId) into xx FROM Prj_ViewedLog 
WHERE projId = projId_1 AND userId = userId_1 AND userType = userType_1;
if xx<>0 then
RETURN;
ELSE
INSERT INTO Prj_ViewedLog (projId, userId, userType) VALUES (
projId_1, userId_1, userType_1);
end if;
end;
/


create or replace PROCEDURE WorkPlanShare_Insert (
	workid_1 integer  ,
	userid_1 integer   ,	
	usertype_1 integer   ,
	sharelevel_1 integer   ,
	flag out integer  , msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS 
begin
/*
IF EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workid_1 
AND userid = @userid_1 AND usertype = @usertype_1 AND sharelevel = @sharelevel_1)
RETURN
IF (@sharelevel_1 = 2 AND EXISTS(SELECT workid FROM WorkPlanShareDetail WHERE workid = @workid_1 
AND userid = @userid_1 AND usertype = @usertype_1 AND sharelevel = 1))
BEGIN
UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = @workid_1 AND userid = @userid_1 AND 
usertype = @usertype_1
RETURN
END
*/
INSERT INTO WorkPlanShareDetail
	(workid , userid , usertype , sharelevel)
	VALUES
	(workid_1 , userid_1 , usertype_1 , sharelevel_1);
end;
/


create or replace PROCEDURE WorkPlan_Insert (
	type_n_1  char  ,
	name_1  varchar2   ,
	resourceid_1  varchar2   ,
	begindate_1  char   ,
	begintime_1  char   ,
	enddate_1  char   ,
	endtime_1  char   ,	
	description_1  varchar2    ,
	requestid_1  varchar2   ,
	projectid_1  varchar2   ,
	crmid_1  varchar2   ,
	docid_1  varchar2   ,
	meetingid_1  varchar2   ,	
	status_1  char   ,
	isremind_1 integer  ,
	waketime_1 integer  ,	
	createrid_1 integer   ,
	createdate_1 char   ,
	createtime_1 char ,
	deleted_1 char   ,
	taskid_1 varchar2,
	urgentLevel_1 char,
	agentId_1 integer,
    flag out integer  , 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS 
 m_id integer;
 m_deptId integer;
 m_subcoId integer;
begin
INSERT INTO WorkPlan (
	type_n ,
	name  ,
	resourceid ,
	begindate ,
	begintime ,
	enddate ,
	endtime  ,
	description ,
	requestid  ,
	projectid ,
	crmid  ,
	docid  ,
	meetingid ,
	status  ,
	isremind  ,
	waketime  ,	
	createrid  ,
	createdate  ,
	createtime ,
	deleted,
	taskid,
	urgentLevel,
	agentId
) VALUES (
	type_n_1 ,
	name_1  ,
	resourceid_1 ,
	begindate_1 ,
	begintime_1 ,
	enddate_1 ,
	endtime_1  ,
	description_1 ,
	requestid_1  ,
	projectid_1 ,
	crmid_1  ,
	docid_1  ,
	meetingid_1 ,
	status_1  ,
	isremind_1  ,
	waketime_1  ,	
	createrid_1  ,
	createdate_1  ,
	createtime_1 ,
	deleted_1,
	taskid_1,
	urgentLevel_1,
	agentId_1
);

SELECT MAX(id) into m_id FROM WorkPlan;
SELECT departmentid, subcompanyid1 INTO m_deptId , m_subcoId  FROM HrmResource WHERE id = 
createrid_1;
UPDATE WorkPlan SET deptId = m_deptId, subcompanyId = m_subcoId where id = m_id;
open thecursor for 
 select m_id  id  from dual;
end;
/

create or replace PROCEDURE WorkPlan_Update (
	id_1 	integer,
	name_1  varchar2   ,
	resourceid_1  varchar2   ,
	begindate_1  char   ,
	begintime_1  char    ,
	enddate_1  char   ,
	endtime_1  char   ,	
	description_1  varchar2   ,
	requestid_1  varchar2   ,
	projectid_1  varchar2   ,
	crmid_1  varchar2   ,
	docid_1  varchar2   ,
	meetingid_1  varchar2   ,	
	isremind_1 integer  ,
	waketime_1 integer  ,
	taskid_1 varchar2,
	urgentLevel_1 char,
	agentId_1 integer,
	flag out integer  , 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS 
begin
UPDATE WorkPlan SET
	name = name_1,
	resourceid = resourceid_1,
	begindate = begindate_1,
	begintime = begintime_1,
	enddate = enddate_1,
	endtime  = endtime_1,
	description = description_1,
	requestid  = requestid_1,
	projectid = projectid_1,
	crmid  = crmid_1,
	docid  = docid_1,
	meetingid = meetingid_1,
	isremind  = isremind_1,
	waketime  = waketime_1,	
	taskid = taskid_1,
	urgentLevel = urgentLevel_1,
	agentId = agentId_1
WHERE id = id_1;
end;
/


CREATE or replace PROCEDURE CRM_ContactLog_WorkPlan (
    flag out integer  , 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS 
m_logid integer;
m_customerid integer;
m_resourceid integer;
m_subject varchar2(100);
m_contactdate char(10);
m_contacttime char(8);
m_enddate char(10);
m_endtime char(10);
m_contactinfo varchar2(4000);
m_documentid integer;
m_submitdate char(10);
m_submittime char(8);
m_isfinished smallint;
m_isprocessed smallint;
m_agentid integer;
m_status char(1);
m_workid integer;
m_userid integer;
m_usertype integer;
m_deptId integer;
m_subcoId integer;
m_id integer;
begin
for  all_cursor  in(
SELECT id, customerid, resourceid, subject, contactdate, 
contacttime, enddate, endtime, contactinfo, documentid, 
submitdate, submittime, isfinished, isprocessed, agentid FROM CRM_ContactLog)
loop
   m_logid := all_cursor.id;
   m_customerid := all_cursor.customerid;
   m_resourceid := all_cursor.resourceid;
   m_subject := all_cursor.subject;
   m_contactdate := all_cursor.contactdate; 
   m_contacttime := all_cursor.contacttime; 
   m_enddate := all_cursor.enddate;
   m_endtime := all_cursor.endtime; 
   m_contactinfo := all_cursor.contactinfo; 
   m_documentid := all_cursor.documentid;
   m_submitdate := all_cursor.submitdate;
   m_submittime := all_cursor.submittime;
   m_isfinished := all_cursor.isfinished;
   m_isprocessed := all_cursor.isprocessed;
   m_agentid := all_cursor.agentid;
IF (m_subject <> 'Create') then

  IF m_isfinished = 0 then
     m_status := '0';
  elsif m_isprocessed = 0 then 
           m_status := '1';
  ELSE
     m_status := '2';
  end if;

  INSERT INTO WorkPlan (
  type_n, urgentLevel, crmid, resourceid, name, begindate, begintime, enddate, endtime, description, 
  docid, createdate, createtime,agentId, status, createrid) VALUES ('3', '1', m_customerid, m_resourceid, m_subject, 
  m_contactdate, m_contacttime,m_enddate, m_endtime, m_contactinfo, m_documentid, m_submitdate, m_submittime, m_agentid, 
  m_status, m_resourceid);
  
  SELECT MAX(id) into m_workid  FROM WorkPlan;

  select count(id) into m_id FROM CRM_SellChance WHERE comefromid = m_logid;
  if m_id <> 0 then
  UPDATE CRM_SellChance SET comefromid = m_workid WHERE comefromid = m_logid;
  end if;

  SELECT departmentid, subcompanyid1 into m_deptId  , m_subcoId  FROM HrmResource WHERE id = 
  m_resourceid;
  UPDATE WorkPlan SET deptId = m_deptId, subcompanyId = m_subcoId where id = m_workid;

  INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) 
  SELECT m_workid, userid, usertype , 0 FROM CrmShareDetail WHERE crmid = m_customerid;
end if;
end loop;
end;
/

CREATE or replace PROCEDURE CRM_Share_WorkPlan (
crmId_1 integer, flag out integer  , 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS 
  m_workid integer;
  m_userid integer;
  m_usertype integer;
  m_countId integer ;
  begin
     for  all_cursor in (SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char( crmId_1))
loop
  m_workid := all_cursor.id;
  for  m_cursor in
     (SELECT userid, usertype FROM CrmShareDetail WHERE crmid = crmId_1)
         loop
              m_userid := m_cursor.userid;
              m_usertype := m_cursor.usertype;
         SELECT count(workid)  into m_countId FROM WorkPlanShareDetail WHERE workid = m_workid 
                AND userid = m_userid AND usertype = m_usertype ;

                if m_countId = 0 then                     
                    INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
                    m_workid, m_userid, m_usertype, 0) ;
   end if;
   end loop;
   end loop;
  end ;
/ 

create or replace  PROCEDURE Prj_TaskProcess_Insert 
 (prjid_1 	integer,
 taskid_2 	integer, 
 wbscoding_3 	varchar2,
 subject_4 	varchar2 , 
 version_5 	smallint, 
 begindate_6 	varchar2,
 enddate_7 	varchar2, 
 workday_8  number,
 content_9 	varchar2,
 fixedcost_10  number ,
 parentid_11  integer, 
 parentids_12 varchar2, 
 parenthrmids_13 varchar2, 
 level_n_14 smallint,
 hrmid_15 integer,
 prefinish_1 varchar2,
 realManDays_16 number , 
 flag out integer  , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
dsporder_9 integer;
current_maxid integer;
id_1 integer;
maxid_1 varchar2(10);
maxhrmid_1 varchar2(255);
begin
select max(dsporder) into current_maxid from Prj_TaskProcess 
    where prjid = prjid_1 and version = version_5 and parentid = parentid_11 and isdelete<>'1' ;
if current_maxid is null then  
     current_maxid := 0;
     dsporder_9 := current_maxid + 1;
end if;

INSERT INTO Prj_TaskProcess 
( prjid, 
taskid , 
wbscoding,
subject , 
version , 
begindate, 
enddate, 
workday, 
content, 
fixedcost,
parentid, 
parentids, 
parenthrmids,
level_n, 
hrmid,
islandmark,
prefinish,
dsporder,
realManDays
)  
VALUES 
( prjid_1, taskid_2 , wbscoding_3, subject_4 , version_5 , begindate_6, enddate_7,
workday_8, content_9, fixedcost_10, parentid_11, parentids_12, parenthrmids_13, level_n_14, 
hrmid_15,'0',prefinish_1,dsporder_9, realManDays_16) ;

select max(id) into id_1 from Prj_TaskProcess ;
 maxid_1 := concat(to_char(id_1) , ',');
 maxhrmid_1 := concat(concat(concat(concat('|' , to_char(id_1)) , ',' ),to_char(hrmid_15) ), '|');
 update Prj_TaskProcess set parentids =parentids_12 +maxid_1, parenthrmids = parenthrmids_13+maxhrmid_1  where 
id=id_1;
 end;
/

create or replace  PROCEDURE Prj_TaskProcess_Update 
 (id_1	integer,
 wbscoding_2 varchar2,
 subject_3 	varchar2 ,
 begindate_4 	varchar2,
 enddate_5 	varchar2, 
 workday_6     number, 
 content_7 	varchar2,
 fixedcost_8 number, 
 hrmid_9 integer, 
 oldhrmid_10 integer, 
 finish_11 smallint, 
 taskconfirm_12 char,
 islandmark_13 char,
 prefinish_1 varchar2,
 realManDays_14 number ,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
currenthrmid varchar2(255);
currentoldhrmid varchar2(255);

begin
UPDATE Prj_TaskProcess  
SET  
wbscoding = wbscoding_2, 
subject = subject_3 ,
begindate = begindate_4,
enddate = enddate_5 	, 
workday = workday_6, 
content = content_7,
fixedcost = fixedcost_8,
hrmid = hrmid_9, 
finish = finish_11 ,
taskconfirm = taskconfirm_12,
islandmark = islandmark_13,
prefinish = prefinish_1,
realManDays = realManDays_14 
WHERE ( id = id_1) ;

if hrmid_9 <>oldhrmid_10 then
currenthrmid := concat(concat(concat(concat('|' ,to_char(id_1)) ,',') ,to_char(hrmid_9)) ,'|');
currentoldhrmid:= concat(concat(concat(concat('|' ,to_char(id_1)) , ',' ) , to_char(oldhrmid_10)) , '|');

UPDATE Prj_TaskProcess set parenthrmids = replace(parenthrmids,currentoldhrmid,currenthrmid) 
where (parenthrmids like concat(concat('%',currentoldhrmid),'%'));
end if;

end;
/

CREATE or replace PROCEDURE WorkPlan_SetAllDeptSubco
AS
m_id integer;
m_createrId integer;
m_deptId integer;
m_subcoId integer;
begin
for all_cursor in(
SELECT id, createrid FROM WorkPlan )
loop
  m_id := all_cursor.id;
  m_createrId := all_cursor.createrid;
  SELECT departmentid, subcompanyid1 into m_deptId, m_subcoId  FROM HrmResource WHERE id = m_createrId;
  UPDATE WorkPlan SET deptId = m_deptId, subcompanyId = m_subcoId where id = m_id;
end loop;
end;
/


call WorkPlan_SetAllDeptSubco()
/
DROP PROCEDURE WorkPlan_SetAllDeptSubco 
/

create or replace  PROCEDURE Prj_TaskModifyLog_Insert 
  (
ProjID_1	   integer ,
TaskID_1	   integer ,
Subject_1	   VARCHAR2,
HrmID_1	   integer ,
BeginDate_1  VARCHAR2 ,
EndDate_1	   VARCHAR2 ,
WorkDay_1	   number  ,
FixedCost_1  number ,
Finish_1	   smallint ,
ParentID_1 integer,
Prefinish_1  VARCHAR2  ,
IsLandMark_1 Char ,
ModifyDate_1 VARCHAR2,
ModifyTime_1 VARCHAR2,
ModifyBy_1   integer ,
Status_1	   smallint ,
OperationType_1	smallint,
ClientIP_1	Varchar2,
realManDays number,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO Prj_TaskModifyLog (
ProjID	   ,
TaskID	   ,
Subject	   ,
HrmID	   ,
BeginDate  ,
EndDate	   ,
WorkDay	   ,
FixedCost  ,
Finish	   ,
ParentID   ,
Prefinish  ,
IsLandMark ,
ModifyDate ,
ModifyTime ,
ModifyBy   ,
Status	   ,
OperationType	,
ClientIP,
realManDays
)
VALUES(
ProjID_1	   ,
TaskID_1	   ,
Subject_1	   ,
HrmID_1	   ,
BeginDate_1       ,
EndDate_1	   ,
WorkDay_1	   ,
FixedCost_1       ,
Finish_1	   ,
ParentID_1        ,
Prefinish_1  ,
IsLandMark_1 ,
ModifyDate_1 ,
ModifyTime_1 ,
ModifyBy_1   ,
Status_1	   ,
OperationType_1	,
ClientIP_1,
realManDays
);
end;
/
CREATE OR REPLACE PROCEDURE WorkPlanExchange_Insert (
     workPlanId_1 integer, 
     memberId_1 integer, 
     memberType_1 char,
	 flag out integer,
	 msg out varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)
AS
BEGIN 
INSERT INTO WorkPlanExchange (
    workPlanId, memberId, memberType) VALUES (
    workPlanId_1, memberId_1, memberType_1);
END;
/

CREATE or REPLACE TRIGGER Tri_Update_HrmRoleMembersShare
after insert or update or delete ON  HrmRoleMembers
FOR each row
Declare roleid_1 integer;
        resourceid_1 integer;
        oldrolelevel_1 char(1);
        rolelevel_1 char(1);
        docid_1	 integer;
	    crmid_1	 integer;
	    prjid_1	 integer;
	    cptid_1	 integer;
        sharelevel_1  integer;
        departmentid_1 integer;
	    subcompanyid_1 integer;
        seclevel_1	 integer;
        countrec      integer;
        countdelete   integer;
        countinsert   integer;
		managerstr_11 varchar2(200); 
        oldroleid_1 integer;
        oldresourceid_1 integer;
        contractid_1	 integer;/*2003-11-06杨国生*/
        contractroleid_1 integer ;  /*2003-11-06杨国生*/
        sharelevel_Temp integer ;  /*2003-11-06杨国生*/
        workPlanId_1 integer; /* added by lupeng 2004-07-22 */ 
        m_countworkid integer;  /* 2004-10-27 dongyuqin*/
/* 某一个人加入一个角色或者在角色中的级别升高进行处理,这两种情况都是增加了共享的范围,不需要删除
原有共享信息,只需要判定增加的部分, 对于在角色中级别的降低或者删除某一个成员,只能删除全部共享细节,从作人力资源一个
人的部门或者安全级别改变的操作 */
begin
countdelete := :old.id;
countinsert := :new.id;
oldrolelevel_1 := :old.rolelevel;
oldroleid_1 :=  :old.roleid; 
oldresourceid_1 := :old.resourceid;

if countdelete is null then
    countdelete := 0 ;
else 
    if countinsert is null then
        countinsert := 0 ;
    end if ;
end if ;


if countinsert > 0 then
	roleid_1 := :new.roleid;
	resourceid_1 := :new.resourceid;
	rolelevel_1 := :new.rolelevel;
else 
	roleid_1 := :old.roleid;
	resourceid_1 := :old.resourceid;
	rolelevel_1 := :old.rolelevel;
end if;

if resourceid_1 = 1 then 
    return ;
end if ;

/* 如果有删除原有数据，则将许可表中的权限许可数减一 */
if (countdelete > 0) then
    select seclevel into seclevel_1  from hrmresource where id = oldresourceid_1 ;
    if seclevel_1 is not null then
        Doc_DirAcl_DUserP_RoleChange (oldresourceid_1, oldroleid_1, oldrolelevel_1, seclevel_1);
    end if;
end if;
/* 如果有增加新数据，则将许可表中的权限许可数加一 */
if (countinsert > 0) then
    select  seclevel into seclevel_1 from hrmresource where id = resourceid_1;
    if seclevel_1 is not null then
        Doc_DirAcl_GUserP_RoleChange (resourceid_1, roleid_1, rolelevel_1, seclevel_1);
    end if;
end if;


if ( countinsert >0 and ( countdelete = 0 or rolelevel_1  > oldrolelevel_1 ) )  then   

    select  departmentid ,  subcompanyid1 ,  seclevel INTO  departmentid_1 ,subcompanyid_1 ,seclevel_1 
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null  then
	departmentid_1 := 0;
	end if;
    if subcompanyid_1 is null  then
	subcompanyid_1 := 0;
	end if;


    if rolelevel_1 = '2'   then    /* 新的角色级别为总部级 */
     

	/* ------- DOC 部分 ------- */

        for sharedocid_cursor IN (select distinct docid , sharelevel from DocShare where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
        
        loop 
			docid_1 := sharedocid_cursor.docid ;
			sharelevel_1 := sharedocid_cursor.sharelevel;
            select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then            
                insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);
            else if sharelevel_1 = 2 then            
                update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
				end if;
			end if;
        end loop;



	/* ------- CRM 部分 ------- */

		for sharecrmid_cursor IN (     select distinct relateditemid , sharelevel from CRM_ShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		crmid_1:=sharecrmid_cursor.relateditemid;
		sharelevel_1 := sharecrmid_cursor.sharelevel;
			select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
			if countrec = 0  then
			
				insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
			
			else if sharelevel_1 = 2  then
			
				update CrmShareDetail set sharelevel = 2 where crmid=crmid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
			end if;
			end if;
           /* added by lupeng 2004-07-22 for customer contact work plan */	
        
	    for ccwp_cursor in(
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmid_1))
	      loop
               workPlanId_1 := ccwp_cursor.id ;
                 select count(workid) into m_countworkid  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1;
	    	 if m_countworkid  = 0 then
		INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			workPlanId_1, resourceid_1, 1, 1);
                 end if;
           end loop;
	   /* end */                                            
           
              
		end loop;
	   


	/* ------- PROJ 部分 ------- */

		for shareprjid_cursor IN (      select distinct relateditemid , sharelevel from Prj_ShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		prjid_1 := shareprjid_cursor.relateditemid;
		sharelevel_1 := shareprjid_cursor.sharelevel;
            select count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
             
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid=prjid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
	
  



	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (select distinct relateditemid , sharelevel from CptCapitalShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		cptid_1 :=sharecptid_cursor.relateditemid;
		sharelevel_1 :=sharecptid_cursor.sharelevel;
            select count(cptid) INTO  countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2 then 
            
                update CptShareDetail set sharelevel = 2 where cptid=cptid_1 and userid = resourceid_1 and usertype = 1;  /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;

        /* ------- 客户合同部分 总部 2003-11-06杨国生------- */

        for roleids_cursor in
        (select roleid from SystemRightRoles where rightid = 396) /*396为客户合同管理权限*/
        loop
            for rolecontractid_cursor in
            (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2  
            where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1 and t2.rolelevel=2)
            loop
               select count(contractid) into countrec from ContractShareDetail 
               where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if countrec = 0 then 
                    insert into ContractShareDetail values(contractid_1, resourceid_1, 1, 2);
                else
                    select sharelevel into sharelevel_1 from ContractShareDetail 
                    where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    if sharelevel_1 = 1 then
                         update ContractShareDetail set sharelevel = 2 
                         where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    end if;
                end if;
            end loop;
        end loop; 
           /* for work plan */ 
	 /* added by lupeng 2004-07-22 */
	    for sharewp_cursor in(
         SELECT  DISTINCT workPlanId, shareLevel FROM WorkPlanShare WHERE roleId = roleid_1 AND roleLevel <= rolelevel_1 AND securityLevel <= seclevel_1 )
         loop
         workPlanId_1 := sharewp_cursor.workPlanId;
         sharelevel_1 := sharewp_cursor.shareLevel;
       
	     SELECT COUNT(workid) into countrec FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1; 
             IF  countrec = 0 then 
                 INSERT INTO WorkPlanShareDetail VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
             ELSE IF sharelevel_1 = 2 then
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1 ;/* 共享是可以编辑, 则都修改原有记录 */   
                end if;
             end if;
          end loop;
	 /* end */
              
          
    end if;
    
        
    if rolelevel_1 = '1' then        /* 新的角色级别为分部级 */
    

	/* ------- DOC 部分 ------- */
		for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2 ,
		hrmdepartment  t4 where t1.id=t2.docid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and
		t2.seclevel <= seclevel_1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= subcompanyid_1)
		
		loop 
			docid_1 := sharedocid_cursor.docid;
			sharelevel_1 := sharedocid_cursor.sharelevel;
			select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid = resourceid_1 and usertype = 1 ; 
			if countrec = 0  then            
				insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);            
			else if sharelevel_1 = 2  then            
				update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
			end if;
			end if;
		end loop;


	/* ------- CRM 部分 ------- */
       for sharecrmid_cursor IN (      select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department = t4.id and t4.subcompanyid1= subcompanyid_1)
	   loop
	   crmid_1 :=sharecrmid_cursor.relateditemid;
	   sharelevel_1 :=sharecrmid_cursor.sharelevel;
            select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CrmShareDetail set sharelevel = 2 where crmid = crmid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
              
           /* added by lupeng 2004-07-22 for customer contact work plan */	
	    for ccwp_cursor in(
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmid_1))
	    loop
            workPlanId_1 := ccwp_cursor.id ;
                select count(workid) into m_countworkid  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 
			AND userid = resourceid_1 AND usertype = 1;	
                if  m_countworkid = 0 then 
		        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			workPlanId_1, resourceid_1, 1, 1);
		     end if;
        end loop;
	   /* end */      
	   end loop;

  

	/* ------- PRJ 部分 ------- */

		for shareprjid_cursor IN (        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department=t4.id and t4.subcompanyid1= subcompanyid_1)
		loop
		prjid_1 := shareprjid_cursor.relateditemid;
		sharelevel_1 :=shareprjid_cursor.sharelevel;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid=prjid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
              
		end loop;
	

	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1)
		loop
		cptid_1 :=sharecptid_cursor.relateditemid;
		sharelevel_1 :=sharecptid_cursor.sharelevel;
            select  count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CptShareDetail set sharelevel = 2 where cptid=cptid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;

         /* ------- 客户合同部分 分部 2003-11-06杨国生------- */
        for roleids_cursor in
        (select roleid from SystemRightRoles where rightid = 396) /*396为客户合同管理权限*/
        loop
            for rolecontractid_cursor in
            (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2  
            where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1 
            and (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 ))
            loop
               select count(contractid) into countrec from ContractShareDetail 
               where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if countrec = 0 then
                    insert into ContractShareDetail values(contractid_1, resourceid_1, 1, 2);
                else   
                    select sharelevel into sharelevel_1 from ContractShareDetail 
                    where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    if sharelevel_1 = 1 then
                         update ContractShareDetail set sharelevel = 2 
                         where contractid = contractid_1 and userid = resourceid_1 and usertype = 1  ;
                    end if;
                end if;
            end loop;
        end loop; 


         /* for work plan */ 
	 /* added by lupeng 2004-07-22 */
	 for sharewp_cursor in(
         SELECT DISTINCT t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2 WHERE t1.id = t2.workPlanId AND t2.roleId = roleid_1 AND t2.roleLevel <= rolelevel_1 AND t2.securityLevel <= seclevel_1 AND t1.subcompanyId = subcompanyid_1)
         loop
         workPlanId_1 := sharewp_cursor.workPlanId;
         sharelevel_1 := sharewp_cursor.shareLevel;
	     SELECT COUNT(workid) into countrec  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1  ;
             IF (countrec = 0) then 
                 INSERT INTO WorkPlanShareDetail VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
             ELSE IF (sharelevel_1 = 2) then 
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
             end if;
             end if;
         end loop;         
      
	 /* end */ 
    end if;
        
    
    if rolelevel_1 = '0'     then     /* 为新建时候设定级别为部门级 */
    

        /* ------- DOC 部分 ------- */

		for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2
		where t1.id=t2.docid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <=
		seclevel_1 and t1.docdepartmentid= departmentid_1)
		
		loop 
			docid_1 := sharedocid_cursor.docid ;
			sharelevel_1 := sharedocid_cursor.sharelevel ;
			select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid =
			resourceid_1 and usertype = 1  ;
			if countrec = 0  then            
				insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);            
			else if sharelevel_1 = 2  then            
				update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and
				usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
			end if;
			end if;
		end loop;
	
	/* ------- CRM 部分 ------- */

		for sharecrmid_cursor IN (select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department = departmentid_1)
		loop
		crmid_1 :=sharecrmid_cursor.relateditemid;
		sharelevel_1 :=sharecrmid_cursor.sharelevel;
          select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CrmShareDetail set sharelevel = 2 where crmid = crmid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
              
                /* added by lupeng 2004-07-22 for customer contact work plan */	
	    for ccwp_cursor in(
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmid_1))
	    loop
            workPlanId_1 := ccwp_cursor.id ;
            select count(workid) into m_countworkid FROM WorkPlanShareDetail WHERE workid = workPlanId_1 
			AND userid = resourceid_1 AND usertype = 1;
            if m_countworkid =0 then
		INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			workPlanId_1, resourceid_1, 1, 1);
	    end if;
            end loop;
	   /* end */       
 end loop;
        
  

	/* ------- PRJ 部分 ------- */

		for shareprjid_cursor IN (       select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department= departmentid_1)
		loop
		prjid_1 :=shareprjid_cursor.relateditemid;
		sharelevel_1 := shareprjid_cursor.sharelevel;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
 


	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (       select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.departmentid= departmentid_1)
		loop
		 cptid_1 :=sharecptid_cursor.relateditemid;
		 sharelevel_1 := sharecptid_cursor.sharelevel;
            select count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CptShareDetail set sharelevel = 2 where cptid = cptid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop; 
        
        /* ------- 客户合同部分 部门 2003-11-06杨国生------- */
        for roleids_cursor in
        (select roleid from SystemRightRoles where rightid = 396) /*396为客户合同管理权限*/
        loop
            for rolecontractid_cursor in
            (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2  
            where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1 and 
            (t2.rolelevel=0 and t1.department=departmentid_1 ))
            loop    
               select count(contractid) into countrec from ContractShareDetail 
               where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if countrec = 0  then
                    insert into ContractShareDetail values(contractid_1, resourceid_1, 1, 2);
                else
                    select sharelevel into sharelevel_1 from ContractShareDetail 
                    where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    if sharelevel_1 = 1 then
                         update ContractShareDetail set sharelevel = 2 
                         where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;  
                    end if;
                end if;      
            end loop;

        end loop;   
        
     /* for work plan */ 
	 /* added by lupeng 2004-07-22 */
	 for sharewp_cursor in (
         SELECT  t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2 WHERE t1.id = t2.workPlanId AND t2.roleId = roleid_1 AND t2.roleLevel <= rolelevel_1 AND t2.securityLevel <= seclevel_1 AND t1.deptId = departmentid_1)
         loop
         workPlanId_1 := sharewp_cursor.workPlanId;
         sharelevel_1 := sharewp_cursor.shareLevel;
	     SELECT COUNT(workid) into countrec  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1  ;
             IF (countrec = 0) then 
                 INSERT INTO WorkPlanShareDetail VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
             ELSE IF (sharelevel_1 = 2) then 
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
             end if;
          end loop;
	 /* end */

    end if;
       

else 

if ( countdelete > 0 and ( countinsert = 0 or rolelevel_1  < oldrolelevel_1 ) )  then 
/* 当为删除或者级别降低 */


    select  departmentid ,  subcompanyid1 ,  seclevel INTO departmentid_1 ,subcompanyid_1 ,seclevel_1 
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null then
	departmentid_1 := 0;
    end if;
	if subcompanyid_1 is null then
	subcompanyid_1 := 0;
	end if;
	
    /* 删除原有的该人的所有文档共享信息 */
	delete from DocShareDetail where userid = resourceid_1 and usertype = 1;


    /*  将所有的信息现放到 temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    for docid_cursor IN (select distinct id from DocDetail where ( doccreaterid = resourceid_1 or ownerid = resourceid_1 ) and usertype= '1')
    
    loop 
		docid_1 := docid_cursor.id;
        insert into temptablevalue values(docid_1, 2);
    end loop;



    /* 自己下级的文档 */
    /* 查找下级 */
    managerstr_11 := concat( concat('%,' , to_char(resourceid_1)) , ',%' );

    for subdocid_cursor IN (select distinct id from DocDetail where ( doccreaterid in (select distinct id from
	HrmResource where concat(',' , managerstr) like managerstr_11 ) or ownerid in (select distinct id from
	HrmResource where concat(',' , managerstr) like managerstr_11 ) ) and usertype= '1')
    
    loop
		docid_1 := subdocid_cursor.id;
        select  count(docid) INTO countrec  from temptablevalue where docid = docid_1;
        if countrec = 0 then
		insert into temptablevalue values(docid_1, 1);
		end if;
    end loop;
         
         


    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    for sharedocid_cursor IN (select distinct docid , sharelevel from DocShare  where  (foralluser=1 and
	seclevel<= seclevel_1 )  or ( userid= resourceid_1 ) or (departmentid= departmentid_1 and seclevel<=
	seclevel_1 ))
    
    loop 
		docid_1 :=sharedocid_cursor.docid;
		sharelevel_1 :=sharedocid_cursor.sharelevel;
        select count(docid) INTO countrec  from temptablevalue where docid = docid_1  ;
        if countrec = 0  then        
            insert into temptablevalue values(docid_1, sharelevel_1);        
        else if sharelevel_1 = 2  then        
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* 共享是可以编辑, 则都修改原有记录    */
        end if;
		end if;
    end loop;

    for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2, 
	HrmRoleMembers_Tri  t3 , hrmdepartment t4 where t1.id=t2.docid and t3.resourceid= resourceid_1 and
	t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and
	t1.docdepartmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1=
	subcompanyid_1 ) or (t3.rolelevel=2) ))

    loop
		docid_1 :=sharedocid_cursor.docid ;
		sharelevel_1 := sharedocid_cursor.sharelevel ;
        select  count(docid) INTO countrec  from temptablevalue where docid = docid_1 ; 
        if countrec = 0  then        
            insert into temptablevalue values(docid_1, sharelevel_1);        
        else if sharelevel_1 = 2  then        
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* 共享是可以编辑, 则都修改原有记录    */
			end if;
		end if;
    end loop ;

    /* 将临时表中的数据写入共享表 */
    for alldocid_cursor IN (select * from temptablevalue)    
    loop 
		docid_1 := alldocid_cursor.docid;
		sharelevel_1 := alldocid_cursor.sharelevel;
        insert into docsharedetail values(docid_1, resourceid_1,1,sharelevel_1);
    end loop;

    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
	delete from CrmShareDetail where userid = resourceid_1 and usertype = 1;



    /*  将所有的信息现放到 temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    for crmid_cursor IN (   select id from CRM_CustomerInfo where manager = resourceid_1 )
	loop
	crmid_1 := crmid_cursor.id;
	insert into temptablevaluecrm values(crmid_1, 2);
	end loop;
 


    /* 自己下级的客户 3 */
    /* 查找下级 */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)) , ',%' );

    for subcrmid_cursor IN (  select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	crmid_1 :=  subcrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0  then
		insert into temptablevaluecrm values(crmid_1, 3);
		end if;
	end loop;
  

 
    /* 作为crm管理员能看到的客户 */
    for rolecrmid_cursor IN (   select distinct t1.id from CRM_CustomerInfo  t1, HrmRoleMembers_Tri  t2  where t2.roleid=8 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	crmid_1 := rolecrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
		insert into temptablevaluecrm values(crmid_1, 4);
		end if;
	end loop;



    /* 由客户的共享获得的权利 1 2 */
    for sharecrmid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid = departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	crmid_1:= sharecrmid_cursor.relateditemid;
	sharelevel_1 :=sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
	end loop;






    for sharecrmid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers_Tri  t3  where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department = departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ) )
	loop
	crmid_1 :=sharecrmid_cursor.relateditemid;
	sharelevel_1 := sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
	end loop;




    /* 将临时表中的数据写入共享表 */
    for allcrmid_cursor IN (    select * from temptablevaluecrm)
	loop
	crmid_1 :=allcrmid_cursor.crmid;
	sharelevel_1  := allcrmid_cursor.sharelevel;
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1, resourceid_1,1,sharelevel_1);
	
/* added by lupeng 2004-07-22 for customer contact work plan */	
        for ccwp_cursor in(
        SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmid_1))
        loop
        workPlanId_1 := ccwp_cursor.id ;
            select count(workid) into m_countworkid FROM WorkPlanShareDetail WHERE workid = workPlanId_1 
			AND userid = resourceid_1 AND usertype = 1;
            if m_countworkid = 0 then
	    INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			workPlanId_1, resourceid_1, 1, 1);
	    end if;
        end loop;
	/* end */


	end loop;





    /* ------- PROJ 部分 ------- */



    /*  将所有的信息现放到 temptablevaluePrj 中 */
    /*  自己的项目2 */
    for prjid_cursor IN (select id from Prj_ProjectInfo where manager = resourceid_1 )
	loop
	prjid_1 := prjid_cursor.id;
      insert into temptablevaluePrj values(prjid_1, 2);
	end loop;



    /* 自己下级的项目3 */
    /* 查找下级 */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );

    for subprjid_cursor IN (    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	prjid_1 :=subprjid_cursor.id;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 3);
		end if;
	end loop;


 
    /* 作为项目管理员能看到的项目4 */
    for roleprjid_cursor IN (   select distinct t1.id from Prj_ProjectInfo  t1, HrmRoleMembers_Tri  t2  where t2.roleid=9 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	prjid_1:=roleprjid_cursor.id;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 4);
		end if;
	end loop;

	 


    /* 由项目的共享获得的权利 1 2 */
    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	prjid_1 := shareprjid_cursor.relateditemid;
	sharelevel_1 :=  shareprjid_cursor.sharelevel;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
	end loop;



    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers_Tri  t3  where  t1.id = t2.relateditemid and  t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department=departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ) 
    
	)
	loop
	prjid_1 := shareprjid_cursor.relateditemid;
	sharelevel_1 := shareprjid_cursor.sharelevel;
        select  count(prjid) INTO countrec from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0 then 
        
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
	end loop;

	

    /* 项目成员5 (内部用户) */
    for inuserprjid_cursor IN (    SELECT distinct t2.id FROM Prj_TaskProcess  t1,Prj_ProjectInfo  t2 WHERE  t1.hrmid =resourceid_1 and t2.id=t1.prjid and t1.isdelete<>'1' and t2.isblock='1' )
	loop
	prjid_1 :=inuserprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1 ; 
        if countrec = 0  then
        
            insert into temptablevaluePrj values(prjid_1, 5);
        end if;
	end loop;



    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allprjid_cursor IN (select * from temptablevaluePrj)
	loop
	prjid_1 := allprjid_cursor.prjid;
	sharelevel_1 := allprjid_cursor.sharelevel;
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1, resourceid_1,1,sharelevel_1);
	end loop;
    



    /* ------- CPT 部分 ------- */


    /*  将所有的信息现放到 temptablevalueCpt 中 */
    /*  自己的资产2 */
    for cptid_cursor IN (    select id from CptCapital where resourceid = resourceid_1 )
	loop
	cptid_1 := cptid_cursor.id;
	  insert into temptablevalueCpt values(cptid_1, 2);
	end loop;





    /* 自己下级的资产1 */
    /* 查找下级 */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );

    for subcptid_cursor IN ( select id from CptCapital where ( resourceid in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	cptid_1 := subcptid_cursor.id;
        select  count(cptid) INTO countrec  from temptablevalueCpt where cptid = cptid_1;
        if countrec = 0 then
		insert into temptablevalueCpt values(cptid_1, 1);
		end if;
	end loop;

 
   
    /* 由资产的共享获得的权利 1 2 */
    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	cptid_1 := sharecptid_cursor.relateditemid;
	sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then
        
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end if;
	end loop;




    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers_Tri  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1 ) or (t3.rolelevel=2) ))
	loop
	cptid_1 := sharecptid_cursor.relateditemid;
	sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then
        
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end    if;
	end loop;

    


    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allcptid_cursor IN (select * from temptablevalueCpt)
	loop
	cptid_1 :=allcptid_cursor.cptid;
	sharelevel_1 :=allcptid_cursor.sharelevel;
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1, resourceid_1,1,sharelevel_1);
	end loop;	

    
    
    
    /* ------- 客户合同部分2003-11-06杨国生 ------- */ 
    
    /* 自己下级的客户合同 3 */
     
    managerstr_11:=concat('%,',concat(to_char(resourceid_1), ',%' ));
    for subcontractid_cursor in
    (select id from CRM_Contract
    where (manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
    loop
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0  then
            insert into temptablevaluecontract values(contractid_1, 3);
        end if;
    end loop;

 /*  自己是 manager 的客户合同 2 */
    for contractid_cursor in
    (select id from CRM_Contract where manager = resourceid_1)
    loop
        insert into temptablevaluecontract values(contractid_1, 2);
    end loop;
    
    /* 作为客户合同管理员能看到的 */
    for roleids_cursor in
    (select roleid from SystemRightRoles where rightid = 396)
    loop

       for rolecontractid_cursor in
       (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2  
       where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1 
       and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1 ) 
       or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
       
         loop
            select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
            if countrec = 0 then  
                insert into temptablevaluecontract values(contractid_1, 2);
            else
                select sharelevel into sharelevel_1 from ContractShareDetail where contractid = contractid_1 
                and userid = resourceid_1 and usertype = 1;
                if sharelevel_1 = 1 then
                     update ContractShareDetail 
                     set sharelevel = 2 where contractid = contractid_1 
                     and userid = resourceid_1 and usertype = 1;
                end if;
            end if;  
         end loop;
        
    end loop;
    
      /* 由客户合同的共享获得的权利 1 2 */
    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel from Contract_ShareInfo  t2 
     where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  
     or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)))
    loop
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then  
            insert into temptablevaluecontract values(contractid_1, sharelevel_1);
        else
            select sharelevel into sharelevel_Temp from temptablevaluecontract 
            where contractid = contractid_1;
            if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
               update temptablevaluecontract set sharelevel = sharelevel_1 
               where contractid = contractid_1;
            end if;
         end if;
    end loop;



    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel 
    from CRM_Contract t1 ,  Contract_ShareInfo  t2,  HrmRoleMembers_Tri  t3  
    where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 
    and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel 
    and t2.seclevel<=seclevel_1 
    and ( (t2.rolelevel=0  and t1.department=departmentid_1) 
    or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ))
     
        loop
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;  
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, sharelevel_1);
        else
            select sharelevel into sharelevel_Temp from temptablevaluecontract where contractid = contractid_1;
            if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
              update temptablevaluecontract set sharelevel = sharelevel_1 where contractid = contractid_1;
            end if;
         end if;   
         end loop;
    
    
    /* 自己下级的客户合同  (客户经理及经理线)*/
    
    managerstr_11:= concat('%,',concat(to_char(resourceid_1),',%')); 


    for subcontractid_cursor in   
    (select t2.id from CRM_CustomerInfo t1, CRM_Contract t2 where ( t1.manager in 
    (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11) ) 
    and (t2.crmId = t1.id))
    loop     
        select count(contractid) into countrec from temptablevaluecontract
        where contractid = contractid_1;
        if countrec = 0  then
              insert into temptablevaluecontract values(contractid_1, 1);
        end if;
    end loop;    
 
    /*  自己是 manager 的客户 (客户经理及经理线) */
    for contractid_cursor in
    (select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2 
    where (t1.manager = resourceid_1 ) and (t2.crmId = t1.id))
        loop
          insert into temptablevaluecontract values(contractid_1, 1);
        end loop;


    /* 删除原有的与该人员相关的所有权 */
    delete from ContractShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allcontractid_cursor in
    (select * from temptablevaluecontract)
    loop
        insert into ContractShareDetail( contractid, userid, usertype, sharelevel) 
        values(contractid_1, resourceid_1,1,sharelevel_1);
    end loop;
    
    end if; 
    
    /* for work plan */ 
    /* added by lupeng 2004-07-22 */
    /* delete all the work plan share info of this user */
    /* DELETE WorkPlanShareDetail WHERE userid = @resourceid_1 AND usertype = 1 */

    /* define a temporary table */
    
    /* write the data to the temporary table */
    /* a. the creater of the work plan is this user */
    for  creater_cursor in (SELECT id FROM WorkPlan WHERE createrid = resourceid_1)
    loop
         workPlanId_1 := creater_cursor.id;
        INSERT INTO TmpTableValueWP VALUES (workPlanId_1, 2);
    end loop;

     /* b. the creater of the work plan is my underling */     
    managerstr_11 := concat(concat('%,', to_char(resourceid_1)), ',%' );
    for  underling_cursor in(
    SELECT id FROM WorkPlan WHERE (createrid IN (SELECT DISTINCT id FROM HrmResource WHERE concat(',', MANAGERSTR) LIKE managerstr_11)))
    loop
    workPlanId_1 := underling_cursor.id;

        SELECT COUNT(workPlanId) into countrec  FROM TmpTableValueWP WHERE workPlanId = workPlanId_1;
        IF (countrec = 0)  then 
        INSERT INTO TmpTableValueWP VALUES (workPlanId_1, 1);
        end if;
     end loop;

     
     /* c. in the work plan share info */
    for sharewp_cursor in(
    SELECT DISTINCT workPlanId, shareLevel FROM WorkPlanShare WHERE ((forAll = 1 AND securityLevel <= seclevel_1) OR (userId = resourceid_1) OR (deptId = departmentid_1 AND securityLevel <= seclevel_1)))
    loop
    workPlanId_1 := sharewp_cursor.workPlanId;
    sharelevel_1 := sharewp_cursor.shareLevel;
        SELECT COUNT(workPlanId) into countrec   FROM TmpTableValueWP WHERE workPlanId = workPlanId_1  ;
        IF (countrec = 0) then
            INSERT INTO TmpTableValueWP VALUES (workPlanId_1, sharelevel_1);
        end if;
     end loop;

    for sharewp_cursor in(
    SELECT DISTINCT t2.workPlanId as t2workPlanId, t2.shareLevel as t2shareLevel FROM WorkPlan t1, WorkPlanShare t2, HrmRoleMembers t3 WHERE t1.id = t2.workPlanId AND t3.resourceid = resourceid_1 AND t3.roleid = t2.roleId AND t3.rolelevel >= t2.roleLevel AND t2.securityLevel <= seclevel_1 AND ((t2.roleLevel = 0  AND t1.deptId = departmentid_1) OR (t2.roleLevel = 1 AND t1.subcompanyId = subcompanyid_1) OR (t3.rolelevel = 2)))
    loop
    workPlanId_1 := sharewp_cursor.t2workPlanId;
    sharelevel_1 := sharewp_cursor.t2shareLevel;
        SELECT COUNT(workPlanId) into countrec  FROM TmpTableValueWP WHERE workPlanId = workPlanId_1 ; 
        IF (countrec = 0 ) then
            INSERT INTO TmpTableValueWP VALUES (workPlanId_1, sharelevel_1);
        end if;
    end loop;
    
  /* write the temporary table data to the share detail table */
    for  allwp_cursor in(SELECT * FROM TmpTableValueWP)
    loop
    workPlanId_1 := allwp_cursor.workPlanId;
    sharelevel_1 := allwp_cursor.shareLevel;
        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
    end loop;
    /* end */
    
    /* 结束角色删除或者级别降低的处理 */
end if ;
end ;
/

CREATE or REPLACE  TRIGGER Tri_Update_HrmresourceShare 
after  update  ON Hrmresource 
FOR each row

Declare resourceid_1 integer;
        subresourceid_1 integer;
        supresourceid_1 integer;
        olddepartmentid_1 integer;
        departmentid_1 integer;
        subcompanyid_1 integer;
        oldseclevel_1     integer;
        seclevel_1     integer;
        docid_1     integer;
        crmid_1     integer;
        prjid_1     integer;
        cptid_1     integer;
        sharelevel_1  integer;
        countrec      integer;
        oldmanagerstr_1    varchar2(200);
        managerstr_1    varchar2(200);
        managerstr_11 varchar2(200) ;
        mainid_1    integer;
        subid_1    integer;
        secid_1    integer;
        members_1 varchar2(200);
         contractid_1     integer; /*2003-11-06杨国生*/
        contractroleid_1 integer ;   /*2003-11-06杨国生*/
        sharelevel_Temp integer; /*2003-11-06杨国生*/
        workPlanId_1 integer;    /* added by lupeng 2004-07-22 */
        m_countworkid integer;  /* 2004-10-27 dongyuqin*/
begin

/* 从刚修改的行中查找修改的resourceid 等 */

 olddepartmentid_1 := :old.departmentid;
 oldseclevel_1 := :old.seclevel ;
 oldmanagerstr_1 := :old.managerstr;
 resourceid_1 := :new.id ;
 departmentid_1 := :new.departmentid;
 subcompanyid_1 := :new.subcompanyid1;
 seclevel_1 := :new.seclevel ;
 managerstr_1 := :new.managerstr;

if seclevel_1 is not null then
update HrmResource_Trigger set
seclevel =seclevel_1
where id =resourceid_1;
end if;


if ( departmentid_1 is not null ) then
update HrmResource_Trigger set
departmentid =departmentid_1
where id =resourceid_1;
end if;

if (  managerstr_1 is not null) then
update HrmResource_Trigger set
managerstr =managerstr_1
where id =resourceid_1;
end if;

if subcompanyid_1 is not null then
update HrmResource_Trigger set
subcompanyid1 =subcompanyid_1
where id =resourceid_1;
end if;




/* 如果部门和安全级别信息被修改(在新建的时候这两个信息肯定被修改) */

if ( departmentid_1 <>olddepartmentid_1 or  seclevel_1 <> oldseclevel_1 or oldseclevel_1 is null )  then

    if departmentid_1 is null   then
    departmentid_1 := 0;
    end if;
    if subcompanyid_1 is null   then
    subcompanyid_1 := 0;
    end if;


    /* 修改目录许可表 */
    if ((olddepartmentid_1 is not null) and (oldseclevel_1 is not null)) then
        Doc_DirAcl_DUserP_BasicChange (resourceid_1, olddepartmentid_1, oldseclevel_1);
    end if;
    if ((departmentid_1 is not null) and (seclevel_1 is not null)) then
        Doc_DirAcl_GUserP_BasicChange (resourceid_1, departmentid_1, seclevel_1);
    end if;


    /* 该人新建文档目录的列表 */



    delete from DocUserCategory where userid= resourceid_1 and usertype= '0';

    for all_cursor in(
    select distinct t1.id t1id from docseccategory t1,HrmResource_Trigger t2,hrmrolemembers t5
    where t1.cusertype='0' and t2.id= resourceid_1
    and(( t2.seclevel>= t1.cuserseclevel)
    or( t2.seclevel >= t1.cdepseclevel1 and t2.departmentid=t1.cdepartmentid1)
    or( t2.seclevel >= t1.cdepseclevel2 and t2.departmentid=t1.cdepartmentid2)
    or( t5.roleid=t1.croleid1 and t5.rolelevel=t1.crolelevel1 and t2.id=t5.resourceid )
    or( t5.roleid=t1.croleid2 and t5.rolelevel=t1.crolelevel2 and t2.id=t5.resourceid )
    or( t5.roleid=t1.croleid3 and t5.rolelevel=t1.crolelevel3 and t2.id=t5.resourceid ))
    )
    loop
        secid_1 := all_cursor.t1id;
        select  subcategoryid INTO subid_1 from docseccategory where id=secid_1;
        select  maincategoryid INTO mainid_1 from docsubcategory where id=subid_1;
        insert into  docusercategory (secid,mainid,subid,userid,usertype)
        values (secid_1,mainid_1,subid_1,resourceid_1,'0');
    end loop;

    /* DOC 部分*/

    /* 删除原有的该人的所有文档共享信息 */
    delete from DocShareDetail where userid = resourceid_1 and usertype = 1;



    /*  将所有的信息现放到 temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    for docid_cursor IN (select distinct id from DocDetail where ( doccreaterid = resourceid_1 or ownerid = resourceid_1 ) and usertype= '1')
    loop
    docid_1 := docid_cursor.id;
    insert into temptablevalue values(docid_1, 2);
    end loop;




    /* 自己下级的文档 */
    /* 查找下级 */

     managerstr_11 := concat( concat('%,' , to_char(resourceid_1)) , ',%');

    for subdocid_cursor IN ( select distinct id from DocDetail where ( doccreaterid in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) or ownerid in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ) and usertype= '1')
    loop
    docid_1 :=subdocid_cursor.id;
         select  count(docid) INTO countrec  from temptablevalue where docid = docid_1;
        if countrec = 0 then
        insert into temptablevalue values(docid_1, 1);
        end if;
    end loop;



    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    for  sharedocid_cursor IN (select distinct docid , sharelevel from DocShare  where  (foralluser=1 and seclevel<= seclevel_1 )  or ( userid= resourceid_1 ) or (departmentid= departmentid_1 and seclevel<= seclevel_1 ))
    loop
    docid_1:=sharedocid_cursor.docid;
    sharelevel_1 :=sharedocid_cursor.sharelevel;
        select  count(docid) INTO countrec  from temptablevalue where docid = docid_1  ;
        if countrec = 0  then
            insert into temptablevalue values(docid_1, sharelevel_1);
        else if sharelevel_1 = 2  then
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* 共享是可以编辑, 则都修改原有记录    */ end if;
        end if;
    end loop;



    for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.docid and t3.resourceid= resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and t1.docdepartmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= subcompanyid_1 ) or (t3.rolelevel=2) ))
    loop
    docid_1 :=sharedocid_cursor.docid;
    sharelevel_1 :=sharedocid_cursor.sharelevel;
    select  count(docid) INTO countrec  from temptablevalue where docid = docid_1  ;
        if countrec = 0  then

            insert into temptablevalue values(docid_1, sharelevel_1);

        else if sharelevel_1 = 2  then
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* 共享是可以编辑, 则都修改原有记录    */ end if;
        end if;
    end loop;






    /* 将临时表中的数据写入共享表 */
    for alldocid_cursor IN (select * from temptablevalue)
    loop
    docid_1 :=alldocid_cursor.docid;
    sharelevel_1 := alldocid_cursor.sharelevel;
    insert into docsharedetail values(docid_1, resourceid_1,1,sharelevel_1);
    end loop;




    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
    delete from CrmShareDetail where userid = resourceid_1 and usertype = 1;



    /*  将所有的信息现放到 temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    for crmid_cursor IN (select id from CRM_CustomerInfo where manager = resourceid_1 )
    loop
    crmid_1 :=crmid_cursor.id;
    insert into temptablevaluecrm values(crmid_1, 2);
    end loop;


    /* 自己下级的客户 3 */
    /* 查找下级 */

     managerstr_11 := concat( concat('%,' , to_char(resourceid_1)) , ',%' );

    for subcrmid_cursor IN (select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
    loop
    crmid_1 :=subcrmid_cursor.id;
        select count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
        insert into temptablevaluecrm values(crmid_1, 3);
        end if;
    end loop;



    /* 作为crm管理员能看到的客户 */
    for rolecrmid_cursor IN (   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
    loop
    crmid_1:=rolecrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
        insert into temptablevaluecrm values(crmid_1, 4);
        end if;
    end loop;




    /* 由客户的共享获得的权利 1 2 */
    for sharecrmid_cursor IN (select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
    loop
    crmid_1 := sharecrmid_cursor.relateditemid;
     sharelevel_1:=sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1 ;
        if countrec = 0  then

            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
    end loop;





    for sharecrmid_cursor IN (   select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department=departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) )
    )
    loop
    crmid_1 :=sharecrmid_cursor.relateditemid;
    sharelevel_1 :=sharecrmid_cursor.sharelevel;
        select count(crmid) INTO countrec from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then

            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
    end loop;



    /* 将临时表中的数据写入共享表 */
    for allcrmid_cursor IN (select * from temptablevaluecrm)
    loop
    crmid_1 :=allcrmid_cursor.crmid;
    sharelevel_1 := allcrmid_cursor.sharelevel;
    insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1, resourceid_1,1,sharelevel_1);

    /* added by lupeng 2004-07-22 for customer contact work plan */
        for ccwp_cursor in(
        SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmid_1))
        loop
        workPlanId_1 := ccwp_cursor.id;
        select count(workid)     into  m_countworkid FROM WorkPlanShareDetail WHERE workid = workPlanId_1
            AND userid = resourceid_1 AND usertype = 1;
        if m_countworkid  = 0 then
        INSERT INTO WorkPlanShareDetail(workid, userid, usertype, sharelevel) VALUES (
            workPlanId_1, resourceid_1, 1, 1);
        end if;
        end loop;
    /* end */

    end loop;





    /* ------- PROJ 部分 ------- */



    /*  将所有的信息现放到 temptablevaluePrj 中 */
    /*  自己的项目2 */
    for prjid_cursor IN (select id from Prj_ProjectInfo where manager = resourceid_1 )
    loop
    prjid_1:=prjid_cursor.id;
    insert into temptablevaluePrj values(prjid_1, 2);
    end loop;




    /* 自己下级的项目3 */
    /* 查找下级 */

     managerstr_11 :=  concat(concat('%,' , to_char(resourceid_1)) , ',%' );

    for subprjid_cursor IN (select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
    loop
    prjid_1 :=subprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
        insert into temptablevaluePrj values(prjid_1, 3);
        end if;
    end loop;



    /* 作为项目管理员能看到的项目4 */
    for roleprjid_cursor IN (   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
    loop
    prjid_1 :=roleprjid_cursor.id;
        select count(prjid) INTO  countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
        insert into temptablevaluePrj values(prjid_1, 4);
        end if;
    end loop;




    /* 由项目的共享获得的权利 1 2 */
    for shareprjid_cursor IN ( select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
    loop
    prjid_1 :=shareprjid_cursor.relateditemid;
    sharelevel_1 :=shareprjid_cursor.sharelevel;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then

            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
    end loop;




    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department=departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) )
    )
    loop
     prjid_1 :=shareprjid_cursor.relateditemid;
     sharelevel_1:=shareprjid_cursor.sharelevel;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then

            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end    if;
        end loop;





    /* 项目成员5 (内部用户) */
    members_1 := concat(concat('%,' , to_char(resourceid_1)), ',%' );
    for inuserprjid_cursor IN (  SELECT  id FROM Prj_ProjectInfo   WHERE  ( concat(concat(',',members),',')  LIKE  members_1)  and isblock='1'  )
    loop
    prjid_1 :=inuserprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then

            insert into temptablevaluePrj values(prjid_1, 5);
        end    if;
    end loop;




    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allprjid_cursor IN (select * from temptablevaluePrj)
    loop
    prjid_1 :=allprjid_cursor.prjid;
    sharelevel_1 :=allprjid_cursor.sharelevel;
       insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1, resourceid_1,1,sharelevel_1);
    end loop;



    /* ------- CPT 部分 ------- */



    /*  将所有的信息现放到 temptablevalueCpt 中 */
    /*  自己的资产2 */
    for cptid_cursor IN (select id from CptCapital where resourceid = resourceid_1 )
    loop
    cptid_1 :=cptid_cursor.id;
    insert into temptablevalueCpt values(cptid_1, 2);
    end loop;


    /* 自己下级的资产1 */
    /* 查找下级 */

     managerstr_11 := concat(concat( '%,' , to_char(resourceid_1)),',%');

    for subcptid_cursor IN (
    select id from CptCapital where ( resourceid in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
    loop
    cptid_1 := subcptid_cursor.id;
        select  count(cptid) INTO countrec  from temptablevalueCpt where cptid = cptid_1;
        if countrec = 0  then
        insert into temptablevalueCpt values(cptid_1, 1);
        end if;
    end loop;





    /* 由资产的共享获得的权利 1 2 */
    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
    loop
    cptid_1 :=sharecptid_cursor.relateditemid;
    sharelevel_1 := sharecptid_cursor.sharelevel;
        select  count(cptid) into  countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then

            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end if;
    end loop;




    for  sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1 ) or (t3.rolelevel=2) ))
    loop
    cptid_1:= sharecptid_cursor.relateditemid;
    sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec  from temptablevalueCpt where cptid = cptid_1;
        if countrec = 0 then
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end  if;
    end loop;




    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allcptid_cursor IN (select * from temptablevalueCpt)
    loop
    cptid_1 :=allcptid_cursor.cptid;
    sharelevel_1 := allcptid_cursor.sharelevel;
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1, resourceid_1,1,sharelevel_1);
    end loop;
     /* ------- 客户合同部分2003-11-06杨国生 ------- */

    /* 定义临时表变量 */
    /*Declare @temptablevalueCpt  table(contractid integer,sharelevel integer)*/

    /*  将所有的信息现放到 @temptablevalueCpt 中 */

    /* 自己下级的客户合同 3 */

    /*set @managerstr_11 = '%,' + convert(varchar2(5),@resourceid_1) + ',%' */
    managerstr_11:=Concat ('%,' ,Concat(to_char(resourceid_1),',%'));

    for subcontractid_cursor in(
    select id from CRM_Contract where ( manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
    loop
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0  then
            insert into temptablevaluecontract values(contractid_1, 3);
        end if;
    end loop;

     /*  自己是 manager 的客户合同 2 */
    for contractid_cursor in
    (select id from CRM_Contract where manager = resourceid_1 )
    loop
        insert into temptablevaluecontract values(contractid_1, 2);
    end loop;

       /* 作为客户合同管理员能看到的 */
    for roleids_cursor in
    (select roleid from SystemRightRoles where rightid = 396)
    loop

       for rolecontractid_cursor in
 (select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2
 where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1
 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1 )
 or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))

      loop
            select count(contractid) into countrec from temptablevaluecontract
            where contractid = contractid_1;
            if countrec = 0  then
                insert into temptablevaluecontract values(contractid_1, 2);
            else
                select sharelevel into sharelevel_1 from ContractShareDetail where
                contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if sharelevel_1 = 1 then
                     update ContractShareDetail set sharelevel = 2
                     where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                end if;
            end if;
        end loop;

    end loop;

    /* 由客户合同的共享获得的权利 1 2 */
    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel from Contract_ShareInfo  t2
    where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 )
    or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
    loop
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, sharelevel_1);
        else
            select sharelevel into sharelevel_Temp from temptablevaluecontract where contractid = contractid_1;
            if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
                update temptablevaluecontract set sharelevel = sharelevel_1 where contractid = contractid_1;
            end if;
        end if;
    end loop;



    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel from
    CRM_Contract t1 ,  Contract_ShareInfo  t2,  HrmRoleMembers  t3
    where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and
    t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and
    ( (t2.rolelevel=0  and t1.department=departmentid_1) or
    (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ))
    loop
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, sharelevel_1);
        else
            select sharelevel into sharelevel_Temp from temptablevaluecontract where contractid = contractid_1;
            if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
                update temptablevaluecontract set sharelevel = sharelevel_1 where contractid = contractid_1;
            end if;
        end if;
    end loop;

    /* 自己下级的客户合同  (客户经理及经理线)*/

    managerstr_11:=concat( '%,',concat(to_char(resourceid_1),',%'));

    for subcontractid_cursor in
    (select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2
    where ( t1.manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) )
    and (t2.crmId = t1.id))
    loop
        select count(contractid)  into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, 1);
        end if;
    end loop;
    /*  自己是 manager 的客户 (客户经理及经理线) */
    for contractid_cursor in
    (select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2
    where (t1.manager = resourceid_1 ) and (t2.crmId = t1.id))
    loop
        insert into temptablevaluecontract values(contractid_1, 1);
    end loop;

    /* 删除原有的与该人员相关的所有权 */
    delete from ContractShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allcontractid_cursor in
    (select * from temptablevaluecontract)
    loop
        insert into ContractShareDetail( contractid, userid, usertype, sharelevel)
        values(contractid_1, resourceid_1,1,sharelevel_1);
    end loop;


    /* for work plan */
    /* added by lupeng 2004-07-22 */
    /* delete all the work plan share info of this user */
    /* DELETE WorkPlanShareDetail WHERE userid = @resourceid_1 AND usertype = 1 */

    /* write the data to the temporary table */
    /* a. the creater of the work plan is this user */
    for creater_cursor in(
    SELECT id FROM WorkPlan WHERE createrid = resourceid_1)
    loop
    workPlanId_1 := creater_cursor.id;
        INSERT INTO TmpTableValueWP VALUES (workPlanId_1, 2);
    end loop;

       /* b. the creater of the work plan is my underling */
    managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );
    for underling_cursor in(
    SELECT id FROM WorkPlan WHERE (createrid IN (SELECT DISTINCT id FROM HrmResource_Trigger WHERE concat(',' , MANAGERSTR) LIKE managerstr_11)))
    loop
    workPlanId_1 := underling_cursor.id;
        SELECT COUNT(workPlanId) into countrec  FROM TmpTableValueWP WHERE workPlanId = workPlanId_1;
        IF (countrec = 0) then
        INSERT INTO TmpTableValueWP VALUES (workPlanId_1, 1);
        end if;
        end loop;


    /* c. in the work plan share info */
    for sharewp_cursor in(
    SELECT DISTINCT workPlanId, shareLevel FROM WorkPlanShare WHERE ((forAll = 1 AND securityLevel <= seclevel_1) OR (userId = resourceid_1) OR (deptId = departmentid_1 AND securityLevel <= seclevel_1)))
    loop
    workPlanId_1 := sharewp_cursor.workPlanId;
    sharelevel_1 := sharewp_cursor.shareLevel;
        SELECT COUNT(workPlanId) into countrec  FROM TmpTableValueWP WHERE workPlanId = workPlanId_1 ;
        IF (countrec = 0) then
            INSERT INTO TmpTableValueWP VALUES (workPlanId_1, sharelevel_1);
        end if;
        end loop;

    for  sharewp_cursor in(
    SELECT DISTINCT t2.workPlanId as t2workPlanId, t2.shareLevel as t2shareLevel FROM WorkPlan t1, WorkPlanShare t2, HrmRoleMembers t3 WHERE t1.id = t2.workPlanId AND t3.resourceid = resourceid_1 AND t3.roleid = t2.roleId AND t3.rolelevel >= t2.roleLevel AND t2.securityLevel <= seclevel_1 AND ((t2.roleLevel = 0  AND t1.deptId = departmentid_1) OR (t2.roleLevel = 1 AND t1.subcompanyId = subcompanyid_1) OR (t3.rolelevel = 2)) )
    loop
    workPlanId_1 := sharewp_cursor.t2workPlanId;
    sharelevel_1 := sharewp_cursor.t2shareLevel;
        SELECT COUNT(workPlanId) into countrec  FROM TmpTableValueWP WHERE workPlanId = workPlanId_1;
        IF (countrec = 0 ) then
            INSERT INTO TmpTableValueWP VALUES (workPlanId_1, sharelevel_1);
       end if;
       end loop;

/* write the temporary table data to the share detail table */
    for allwp_cursor in (SELECT * FROM TmpTableValueWP)
    loop
    workPlanId_1 := allwp_cursor.workPlanId;
    sharelevel_1 := allwp_cursor.shareLevel;
        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
    end loop;
    /* end */


end if;       /* 结束修改了部门和安全级别的情况 */



/* 对于修改了经理字段,新的所有上级增加对该下级的文档共享,共享级别为可读 */
if ( managerstr_1 <> oldmanagerstr_1 )  then /* 新建人力资源时候对经理字段的改变不考虑 */

    if ( managerstr_1 is not null and length(managerstr_1) > 1 ) then /* 有上级经理 */


         managerstr_1 := concat( ',' , managerstr_1);

    /* ------- DOC 部分 ------- */
        for supuserid_cursor in(select distinct t1.id id_1 , t2.id id_2 from HrmResource_Trigger t1, DocDetail t2 where managerstr_1 like concat(concat('%,',to_char(t1.id)),',%') and ( t2.doccreaterid = resourceid_1 or t2.ownerid = resourceid_1 ) and t2.usertype= '1' )
        loop
        supresourceid_1:= supuserid_cursor.id_1;
        docid_1 := supuserid_cursor.id_2;
            select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid= supresourceid_1 and usertype= 1 ;
            if countrec = 0  then

                insert into docsharedetail values(docid_1,supresourceid_1,1,1);
            end if;
        end loop;


    /* ------- CRM 部分 ------- */
        for supuserid_cursor IN (select distinct t1.id  id_1, t2.id id_2 from HrmResource_Trigger t1, CRM_CustomerInfo t2 where managerstr_1 like concat(concat('%,',to_char(t1.id)),',%') and  t2.manager = resourceid_1  )
        loop
        supresourceid_1:= supuserid_cursor.id_1;
        crmid_1 := supuserid_cursor.id_2;
            select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0 then

                insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1,supresourceid_1,1,3);
            end if;

 /* added by lupeng 2004-07-22 for customer contact work plan */
        for ccwp_cursor in(
        SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmid_1))
        loop
           workPlanId_1 := ccwp_cursor.id;
               select count(workid) into m_countworkid FROM WorkPlanShareDetail WHERE workid = workPlanId_1
            AND userid = resourceid_1 AND usertype = 1;
              if m_countworkid  = 0 then
              INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
            workPlanId_1, resourceid_1, 1, 1);
              end if;
         end loop;
        /* end */

        end loop;



    /* ------- PROJ 部分 ------- */
        for supuserid_cursor IN (    select distinct t1.id  id_1, t2.id id_2 from HrmResource_Trigger t1, Prj_ProjectInfo t2 where managerstr_1 like concat(concat('%,',to_char(t1.id)),',%')  and  t2.manager = resourceid_1 )
        loop
        supresourceid_1:= supuserid_cursor.id_1;
        prjid_1 :=supuserid_cursor.id_2;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0  then

                insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1,supresourceid_1,1,3);
            end if;
        end loop;



    /* ------- CPT 部分 ------- */
        for supuserid_cursor IN (select distinct  t1.id  id_1, t2.id id_2 from HrmResource_Trigger t1, CptCapital t2 where managerstr_1 like concat(concat('%,',to_char(t1.id)),',%') and  t2.resourceid = resourceid_1  )
        loop
        supresourceid_1:=supuserid_cursor.id_1;
        cptid_1:=supuserid_cursor.id_2;
            select  count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0  then
                insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1,supresourceid_1,1,1);
            end if;
        end loop;

         /* ------- 客户合同部分 经理改变 2003-11-06杨国生------- */
        for supuserid_cursor in
        (select distinct t1.id id_1, t2.id id_2 from HrmResource_Trigger t1, CRM_Contract t2
        where managerstr_1 like concat('%,',concat(to_char(t1.id),',%')) and  t2.manager = resourceid_1)
        loop
            supresourceid_1:=supuserid_cursor.id_1;
           cptid_1:=supuserid_cursor.id_2;
            select count(contractid) into countrec from ContractShareDetail where contractid = contractid_1 and
            userid= supresourceid_1 and usertype=1;
            if countrec = 0  then
                insert into ContractShareDetail( contractid, userid, usertype, sharelevel)
                values(contractid_1,supresourceid_1,1,3);
            end if;
        end loop;

        for supuserid_cursor in
        (select distinct t1.id id_1, t3.id id_2 from HrmResource_Trigger t1, CRM_CustomerInfo t2 ,CRM_Contract t3 where managerstr_1
        like concat('%,',concat(to_char(t1.id),',%')) and  t2.manager = resourceid_1  and t2.id = t3.crmId)
        loop
            supresourceid_1:=supuserid_cursor.id_1;
           cptid_1:=supuserid_cursor.id_2;
            select count(contractid) into countrec from ContractShareDetail
            where contractid = contractid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0  then
                insert into ContractShareDetail( contractid, userid, usertype, sharelevel)
                values(contractid_1,supresourceid_1,1,1);
            end if;
        end loop;

      /* for work plan */
    /* added by lupeng 2004-07-22 */
       for  supuserid_cursor in(
        SELECT DISTINCT t1.id  id_1, t2.id  id_2 FROM HrmResource_Trigger t1, WorkPlan t2 WHERE managerstr_1 LIKE concat(concat('%,' , to_char(t1.id)) ,',%') AND t2.createrid = resourceid_1)
        loop
        supresourceid_1 := supuserid_cursor.id_1;
        workPlanId_1 := supuserid_cursor.id_2;
            SELECT COUNT(workid) into countrec  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = supresourceid_1 AND usertype = 1;
            IF (countrec = 0) then
                INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) values(workPlanId_1, supresourceid_1, 1, 1);
            end if;
       end loop;
    /* end */


    end  if;           /* 有上级经理判定结束 */
end if;  /* 修改经理的判定结束 */
end ;
/



/*加入临时表*/
Drop TABLE TEMPTABLEVALUEWORK
/

CREATE GLOBAL TEMPORARY TABLE TEMPTABLEVALUEWORK
(
    WORKID     integer     ,
    USERID     integer     ,
    USERTYPE   integer     ,
    SHARELEVEL integer     
)
ON COMMIT DELETE ROWS
/
/*当会议审批通过时加入到相关人员的工作计划中并加入相应的权限*/
CREATE OR REPLACE TRIGGER Tri_U_bill_WorkPlanByMeet1
AFTER UPDATE ON MEETING REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW WHEN (new.isapproved=2) 
Declare
    name_1 varchar2(80);
     isapproved_1    integer;
     begindate_1    char(10);
     begintime_1  char(8);
     enddate_1    char(10);
     endtime_1    char(8);
    createdate_1    char(10);
     createtime_1  char(8);
     resourceid_1    integer;
     meetingid_1    integer;
     caller_1     integer;
     contacter_1 integer;
    allresource_1 varchar2(200); /*工作计划中的接受人*/
    managerstr_1 varchar2(200);
    managerid integer;
    tmpcount integer ;
    userid_1 integer ;
    usertype_1 integer ;
    sharelevel_1 integer ;
    workplanid_1 integer ;
    workplancount_1 integer ;
    m_deptId integer;
    m_subcoId integer;
    /*all_cursor cursor;*/
    /*detail_cursor cursor*/
begin
    name_1:=:new.name;
    begindate_1:=:new.begindate;
    begintime_1:=:new.begintime;
    enddate_1:=:new.enddate;
    endtime_1:=:new.endtime;
    /*meetingid_1:=:meetingid;*/
    caller_1:=:new.caller;
    createdate_1:=:new.createdate;
    createtime_1:=:new.createtime;
    contacter_1:=:new.contacter;

    if enddate_1=''  then
          enddate_1:=begindate_1;
    end if;

        /* get the department and subcompany info */
	/* added by lupeng 2004-07-22*/
	SELECT departmentid, subcompanyid1 into m_deptId  , m_subcoId FROM HrmResource WHERE id = caller_1;
	/* end */
    
        INSERT INTO WorkPlan
        (type_n ,
        name  ,
        resourceid ,
        begindate ,
        begintime ,
        enddate ,
        endtime  ,
        description ,
        requestid  ,
        projectid ,
        crmid  ,
        docid  ,
        meetingid ,
        status  ,
        isremind  ,
        waketime  ,
        createrid  ,
        createdate  ,
        createtime ,
        deleted,
        urgentLevel,
	deptId,
	subcompanyId)
        values
        ('1' ,
        name_1  ,
        allresource_1 ,
        begindate_1 ,
        begintime_1 ,
        enddate_1 ,
        endtime_1  ,
        '' ,
        '0'  ,
        '0' ,
        '0'  ,
        '0'  ,
        meetingid_1 ,
        '0'  ,
        '1'  ,
        '0'  ,
        caller_1  ,
        createdate_1  ,
        createtime_1  ,
        '0' ,
        '1',
        m_deptId,
        m_subcoId);
    select id into workplanid_1 from WorkPlan where rownum=1 order by id desc;
    allresource_1 :=to_char(caller_1);
    if INSTR (concat(',',concat(allresource_1,',')),concat('%,',concat(to_char(contacter_1),',%')))=0 then

       /*PATINDEX('%,' + convert(varchar2(5),@contacter) + ',%' , ',' + @allresource + ',')*/
       allresource_1:=concat(allresource_1 ,concat  (',', to_char(contacter_1)));
       allresource_1:=to_char(caller_1);
    end if;
    insert into temptablevalueWork values(workplanid_1,caller_1,1,2) ;
    managerstr_1:='';
    select managerstr into managerstr_1 from HrmResource where id = caller_1;
    managerstr_1:= concat('%,', concat(managerstr_1,'%'));
    for allmanagerid_cursor in(
         select id from HrmResource where
         concat(',',concat(to_char(id),',')) like managerstr_1
    )
    loop
         select count(workid) into workplancount_1 from temptablevalueWork
         where workid=workplanid_1 and userid = managerid;
         if workplancount_1 = 0 then
              insert into temptablevalueWork values(workplanid_1,managerid,1,1);
         end if;
    end loop;
    /*召集人及其经理线权限--end*/

    /*联系人及其经理线权限--begin*/
    select count(workid) into workplancount_1 from temptablevalueWork
    where workid = workplanid_1 and userid = contacter_1;
    if workplancount_1 = 0 then
         insert into temptablevalueWork values(workplanid_1,contacter_1,1,1);
         managerstr_1:='';
         select managerstr into managerstr_1 from HrmResource where id = contacter_1;
         managerstr_1:=concat('%,',concat(managerstr_1,'%'));
         for allmanagerid_cursor in(
         select id from HrmResource where concat(',',concat(to_char(id),',')) like managerstr_1
         )
         loop
              select count(workid) into workplancount_1 from temptablevalueWork
              where workid = workplanid_1 and userid = managerid;
              if workplancount_1 = 0 then
                insert into temptablevalueWork values(workplanid_1,managerid,1,1);
              end if;
         end loop;
    end if;
    /*联系人及其经理线权限--end*/

    for detail_cursor in(
    select memberid from Meeting_Member2 where meetingid=meetingid_1 and membertype=1
    )
    loop
         /*if PATINDEX('%,' + convert(varchar2(5),@resourceid) + ',%' , ',' + @allresource + ',') = 0*/
         if INSTR(concat(',' ,concat(allresource_1, ',')),concat('%,',concat(to_char(resourceid_1),',%')))=0 then
              /*allresource_1:=to_char(caller_1);*/
              allresource_1:= concat(allresource_1,concat(',' , to_char(resourceid_1)));
              select count(workid) into workplancount_1 from temptablevalueWork
              where workid = workplanid_1 and userid = resourceid_1;
               if workplancount_1 = 0 then
                   insert into temptablevalueWork values(workplanid_1,resourceid_1,1,1);
                   managerstr_1:='';
                   select managerstr into managerstr_1 from HrmResource where id = resourceid_1;
                   managerstr_1:=concat('%,',concat(managerstr_1,'%'));

                   for allmanagerid_cursor in(
                   select id from HrmResource where concat(',',concat(to_char(id),',')) like managerstr_1
                   )
                   loop
                        select count(workid) into workplancount_1 from temptablevalueWork
                        where workid = workplanid_1 and userid = managerid;
                        if workplancount_1 = 0 then
                             insert into temptablevalueWork values(workplanid_1,managerid,1,1);
                        end if;
                   end loop;
               end if;
         end if;
    end loop;
    update WorkPlan set resourceid=allresource_1 where id =workplanid_1;

    for allmeetshare_cursor in(
    select * from temptablevalueWork
    )
    loop
        insert into WorkPlanShareDetail values(meetingid_1, userid_1, usertype_1, sharelevel_1);
    end loop;
end;
/

CREATE  INDEX WorkPlanShareDetail_ID ON WorkPlanShareDetail(workid,userid,usertype) 
/

CREATE  INDEX WorkPlanExchange_ID ON WorkPlanExchange(workPlanId,memberId) 
/



CREATE or replace PROCEDURE WorkPlanExchange_WP_Add (
workPlanId_1 integer)
AS
m_userid integer;
begin
for  all_cursor in(
SELECT DISTINCT userid FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND usertype = 1)
loop
 m_userid := all_cursor.userid;
 WorkPlanExchange_Insert(workPlanId_1, m_userid);
end loop;
end;
/

CREATE or replace PROCEDURE WorkPlanExchange_Add(
userId_1 integer,
workPlanId_1 integer)
AS
m_counworkPlanId integer;
begin
select count(workPlanId) into m_counworkPlanId FROM WorkPlanExchange WHERE workPlanId = workPlanId_1;
 if m_counworkPlanId  = 0 then
 WorkPlanExchange_WP_Add(workPlanId_1);
 end if;
 select count(workPlanId) into m_counworkPlanId FROM WorkPlanExchange WHERE workPlanId = workPlanId_1 AND memberId = userId_1;
if m_counworkPlanId  <> 0 then
UPDATE WorkPlanExchange SET exchangeCount = exchangeCount + 1 WHERE workPlanId = workPlanId_1 AND memberId <> userId_1;
ELSE
 WorkPlanExchange_Insert(workPlanId_1, userId_1);
end if;
end ;
/

INSERT INTO HtmlLabelIndex values(17505,'被打分人') 
/
INSERT INTO HtmlLabelInfo VALUES(17505,'被打分人',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17505,'Checked user',8) 
/
 
INSERT INTO HtmlLabelIndex values(17506,'得分') 
/
INSERT INTO HtmlLabelInfo VALUES(17506,'得分',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17506,'Score',8) 
/
 
 CREATE or replace PROCEDURE CRM_ShareByHrm_WorkPlan (
crmId_1 integer, userId_1 integer, 
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
m_workid integer;
m_counworkPlanId integer;
begin
for  all_cursor in(
SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmId_1))
loop
m_workid := all_cursor.id;
select count(workid) into m_counworkPlanId FROM WorkPlanShareDetail WHERE workid = m_workid 
AND userid = userId_1 AND usertype = 1;
 if m_counworkPlanId  = 0 then
INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
m_workid, userId_1, 1, 0);
end if;
end loop;
end ;
/

CREATE or replace PROCEDURE CRM_Share_WorkPlan_Del (
crmId_1 integer, 
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
m_workid integer;
begin
for all_cursor in(
SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmId_1))
loop
 m_workid := all_cursor.id;
DELETE WorkPlanShareDetail WHERE workid = m_workid AND sharelevel = 0;
 end loop;
 end ;
/

CREATE TABLE WorkSpaceStyle (
userId integer NOT NULL,
userType char (1) NULL,
styleType char (1) DEFAULT '1'
)
/

 CREATE OR REPLACE PROCEDURE WorkSpaceStyle_Set (
userId_1 integer,
userType_1 char,
styleType_1 char,
flag out     integer,
msg out    varchar2 ,
thecursor IN OUT cursor_define.weavercursor
 )
AS
m_userid integer;
begin

select count(userId) into m_userid FROM WorkSpaceStyle WHERE userId = userId_1 AND userType = userType_1;
if m_userid <>0 then
UPDATE WorkSpaceStyle SET styleType = styleType_1 WHERE userId = userId_1 AND userType = userType_1;
ELSE
INSERT INTO WorkSpaceStyle (userId, userType, styleType) VALUES (userId_1, userType_1, styleType_1);
end if;
end;
/

INSERT INTO HtmlLabelIndex values(17508,'转为计划') 
/
INSERT INTO HtmlLabelInfo VALUES(17508,'转为计划',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17508,'Convert to Work Plan',8) 
/
 
INSERT INTO HtmlLabelIndex values(17520,'查看人') 
/
INSERT INTO HtmlLabelInfo VALUES(17520,'查看人',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17520,'Hrm Resource',8) 
/
 
INSERT INTO HtmlLabelIndex values(17521,'创建的计划') 
/
INSERT INTO HtmlLabelInfo VALUES(17521,'创建的计划',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17521,'Created Work Plan',8) 
/

INSERT INTO HtmlLabelIndex values(17522,'接受的计划') 
/
INSERT INTO HtmlLabelInfo VALUES(17522,'接受的计划',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17522,'Received Work Plan',8) 
/
 
INSERT INTO HtmlLabelIndex values(17523,'所有下属的计划') 
/
INSERT INTO HtmlLabelInfo VALUES(17523,'所有下属的计划',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17523,'All Underling Work Plan',8) 
/

INSERT INTO HtmlLabelIndex values(17524,'计划状态') 
/
INSERT INTO HtmlLabelInfo VALUES(17524,'计划状态',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17524,'Work Plan Status',8) 
/

INSERT INTO HtmlLabelIndex values(17525,'打分状态') 
/
INSERT INTO HtmlLabelInfo VALUES(17525,'打分状态',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17525,'Valuate Status',8) 
/
 
INSERT INTO HtmlLabelIndex values(17526,'未打分') 
/
INSERT INTO HtmlLabelInfo VALUES(17526,'未打分',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17526,'Unvaluated',8) 
/
 
INSERT INTO HtmlLabelIndex values(17527,'已打分') 
/
INSERT INTO HtmlLabelInfo VALUES(17527,'已打分',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17527,'Valuated',8) 
/


ALTER TABLE WorkPlan ADD createrType char(1) DEFAULT '1'
/

ALTER TABLE Exchange_Info ADD (crmIds varchar2(600) NULL, projectIds varchar2(600) NULL, requestIds varchar2(600) NULL)
/

ALTER TABLE Exchange_Info ADD createrType char(1) DEFAULT '1'
/

CREATE or replace PROCEDURE Exchange_Info_Insert (
sortId_1 integer, name_1 varchar2, remark_1 varchar2, creater_1 integer,
createDate_1 char, createTime_1 char, type_n_1 char, docids_1 varchar2,
crmIds_1 varchar2, projectIds_1 varchar2, requestIds_1 varchar2, createrType_1 char,
flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
INSERT INTO Exchange_Info (sortid, name, remark, creater, createDate, createTime, type_n, 
docids, crmIds, projectIds, requestIds, createrType) VALUES (sortId_1, name_1, remark_1, creater_1,
createDate_1, createTime_1, type_n_1, docids_1, crmIds_1, projectIds_1, requestIds_1, createrType_1);
end;
/

ALTER TABLE WorkPlanExchange ADD memberType char(1) DEFAULT '1'
/

create or replace  PROCEDURE WorkPlanExchange_WP_Add (
    workPlanId_1 integer)
AS
m_userid integer;
m_usertype integer;
begin
for  all_cursor in
(SELECT DISTINCT userid, usertype FROM WorkPlanShareDetail WHERE workid = workPlanId_1)
loop
   m_userid := all_cursor.userid;
   m_usertype := all_cursor.usertype;
   WorkPlanExchange_Insert(workPlanId_1, m_userid, m_usertype);
end loop;
end;
/

create or replace  PROCEDURE WorkPlanExchange_Add (
workPlanId_1 integer, userId_1 integer, userType_1 char)
AS
m_workPlanId integer;
begin
select (workPlanId) into m_workPlanId FROM WorkPlanExchange WHERE workPlanId = workPlanId_1;
if m_workPlanId = 0 then
WorkPlanExchange_WP_Add (workPlanId_1);
end if;
UPDATE WorkPlanExchange SET exchangeCount = exchangeCount + 1 
WHERE workPlanId = workPlanId_1 AND 
((memberId <> userId_1 AND memberType = userType_1) OR memberType <> userType_1);
end;
/

ALTER TABLE WorkPlan ADD finishRemind integer DEFAULT 0
/

UPDATE WorkPlan SET finishRemind = 0
/
INSERT INTO HtmlLabelIndex values(17532,'联系记录') 
/
INSERT INTO HtmlLabelInfo VALUES(17532,'联系记录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17532,'Contact History',8) 
/


INSERT INTO HtmlLabelIndex values(17533,'不打分') 
/
INSERT INTO HtmlLabelInfo VALUES(17533,'不打分',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17533,'No Valuate',8) 
/

CREATE or replace PROCEDURE WorkPlan_InsertPlus (
	type_n_1 char,
	name_1 varchar2,
	resourceid_1 varchar2,
	begindate_1 char,
	begintime_1 char,
	enddate_1 char,
	endtime_1 char,	
	description_1 varchar2,
	requestid_1  varchar2,
	projectid_1 varchar2,
	crmid_1 varchar2,
	docid_1 varchar2,
	meetingid_1 varchar2,
	isremind_1 integer,
	waketime_1 integer,	
	createrid_1 integer,
	createrType_1 char,
	createdate_1 char,
	createtime_1 char,	
	taskid_1 varchar2,
	urgentLevel_1 char,	
	status_1 char,
	flag out integer,
    msg out varchar2, 
    thecursor IN OUT cursor_define.weavercursor)
AS 
m_id integer;
m_deptId integer;
m_subcoId integer;
begin
INSERT INTO WorkPlan (
	type_n,
	name,
	resourceid,
	begindate,
	begintime,
	enddate,
	endtime,
	description,
	requestid,
	projectid,
	crmid,
	docid,
	meetingid,
	status,
	isremind,
	waketime,	
	createrid,
	createdate,
	createtime,
	deleted,
	taskid,
	urgentLevel,
	createrType
) VALUES (
	type_n_1,
	name_1,
	resourceid_1,
	begindate_1,
	begintime_1,
	enddate_1,
	endtime_1,
	description_1,
	requestid_1,
	projectid_1,
	crmid_1,
	docid_1,
	meetingid_1,
	status_1,
	isremind_1,
	waketime_1,	
	createrid_1,
	createdate_1,
	createtime_1,
	'0',
	taskid_1,
	urgentLevel_1,
	createrType_1
);
SELECT MAX(id) into m_id  FROM WorkPlan;
SELECT departmentid , subcompanyid1 into m_deptId  , m_subcoId   FROM HrmResource WHERE id = createrid_1;
UPDATE WorkPlan SET deptId = m_deptId, subcompanyId = m_subcoId where id = m_id;
open thecursor for 
select m_id  id  from dual;
end;
/

create or replace PROCEDURE WorkPlan_Update (
	id_1 integer,
	name_1 varchar2,
	resourceid_1 varchar2,
	begindate_1 char,
	begintime_1 char,
	enddate_1 char,
	endtime_1 char,	
	description_1 varchar2,
	requestid_1 varchar2,
	projectid_1 varchar2,
	crmid_1 varchar2,
	docid_1 varchar2,
	meetingid_1 varchar2,	
	isremind_1 integer,
	waketime_1 integer,
	taskid_1 varchar2,
	urgentLevel_1 char,	
	flag out integer,
    msg out varchar2, 
    thecursor IN OUT cursor_define.weavercursor)
AS 
begin
UPDATE WorkPlan SET
	name = name_1,
	resourceid = resourceid_1,
	begindate = begindate_1,
	begintime = begintime_1,
	enddate = enddate_1,
	endtime  = endtime_1,
	description = description_1,
	requestid  = requestid_1,
	projectid = projectid_1,
	crmid  = crmid_1,
	docid  = docid_1,
	meetingid = meetingid_1,
	isremind  = isremind_1,
	waketime  = waketime_1,	
	taskid = taskid_1,
	urgentLevel = urgentLevel_1	
WHERE id = id_1;
end;
/

INSERT INTO HtmlLabelIndex values(17541,'改变样式') 
/
INSERT INTO HtmlLabelInfo VALUES(17541,'改变样式',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17541,'Change Style',8) 
/
INSERT INTO HtmlLabelIndex values(17560,'计划首页') 
/
INSERT INTO HtmlLabelIndex values(17559,'新闻首页') 
/
INSERT INTO HtmlLabelInfo VALUES(17559,'新闻首页',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17559,'',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17560,'计划首页',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17560,'',8) 
/
INSERT INTO HtmlLabelIndex values(17545,'无查看权限') 
/
INSERT INTO HtmlLabelInfo VALUES(17545,'无查看权限',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17545,'No Right',8) 
/
