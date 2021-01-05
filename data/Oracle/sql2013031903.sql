CREATE TABLE Taks_mainlineTask
	(
	id         integer NOT NULL,
	userid     integer NULL,
	mainlineid integer NULL,
	tasktype   integer NULL,
	taskid     integer NULL
	)
/
create sequence Taks_mainlineTask_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Taks_mainlineTask_id_trigger
before insert on Taks_mainlineTask
for each row
begin
select Taks_mainlineTask_id.nextval into :new.id from dual;
end;
/
CREATE INDEX Taks_mainlineTask_Index_1 ON Taks_mainlineTask (taskid)
/
CREATE INDEX Taks_mainlineTask_Index_2 ON Taks_mainlineTask (mainlineid)
/
CREATE TABLE Task_attention
	(
	id       integer NOT NULL,
	userid   integer NULL,
	tasktype integer NULL,
	taskid   integer NULL
	)
/
create sequence Task_attention_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Task_attention_id_trigger
before insert on Task_attention
for each row
begin
select Task_attention_id.nextval into :new.id from dual;
end;
/
CREATE INDEX Task_attention_Index_1 ON Task_attention (taskid)
/
CREATE INDEX Task_attention_Index_2 ON Task_attention (userid)
/
CREATE TABLE Task_label
	(
	id         integer NOT NULL,
	name       VARCHAR2(50) NULL,
	createor   integer NULL,
	createdate VARCHAR2 (25) NULL
	)
/
create sequence Task_label_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Task_label_id_trigger
before insert on Task_label
for each row
begin
select Task_label_id.nextval into :new.id from dual;
end;
/
CREATE TABLE Task_labelTask
	(
	id       integer NOT NULL,
	userid   integer NULL,
	labelid  integer NULL,
	tasktype integer NULL,
	taskid   integer NULL
	)
/
create sequence Task_labelTask_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Task_labelTask_id_trigger
before insert on Task_labelTask
for each row
begin
select Task_labelTask_id.nextval into :new.id from dual;
end;
/
CREATE INDEX Task_labelTask_Index_1 ON Task_labelTask (taskid)
/
CREATE INDEX Task_labelTask_Index_2 ON Task_labelTask (labelid)
/
CREATE TABLE Task_mainline
	(
	id          integer NOT NULL,
	name        VARCHAR2 (50) NULL,
	createor    integer NULL,
	createdate  VARCHAR2 (25) NULL,
	modifydate  VARCHAR2 (25) NULL,
	principalid integer NULL,
	partnerids  VARCHAR2 (4000) NULL,
	remark      VARCHAR2 (4000) NULL
	)
/
create sequence Task_mainline_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Task_mainline_id_trigger
before insert on Task_mainline
for each row
begin
select Task_mainline_id.nextval into :new.id from dual;
end;
/
CREATE TABLE Task_mainlineShare
	(
	id         integer NOT NULL,
	userid     integer NULL,
	mainlineid integer NULL,
	usertype   integer NULL
	)
/
create sequence Task_mainlineShare_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Task_mainlineShare_id_trigger
before insert on Task_mainlineShare
for each row
begin
select Task_mainlineShare_id.nextval into :new.id from dual;
end;
/
CREATE INDEX Task_mainlineShare_Index_1 ON Task_mainlineShare (mainlineid)
/
CREATE INDEX Task_mainlineShare_Index_2 ON Task_mainlineShare (userid)
/
CREATE TABLE Task_msg
	(
	id         integer NOT NULL,
	senderid   integer NULL,
	receiverid integer NULL,
	tasktype   integer NULL,
	taskid     integer NULL,
	content    VARCHAR2 (500) NULL,
	createdate VARCHAR2 (25) NULL,
	type       integer NULL
	)
/
create sequence Task_msg_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Task_msg_id_trigger
before insert on Task_msg
for each row
begin
select Task_msg_id.nextval into :new.id from dual;
end;
/
CREATE INDEX Task_msg_Index_1 ON Task_msg (receiverid)
/
CREATE TABLE Task_operateLog
	(
	id         integer NOT NULL,
	tasktype   integer NULL,
	taskid     integer NULL,
	logid      integer NULL,
	workdate   CHAR (10) NULL,
	userid     integer NULL,
	createdate CHAR (10) NULL,
	createtime CHAR (8) NULL,
	logtype    integer NULL
	)
/
create sequence Task_operateLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Task_operateLog_id_trigger
before insert on Task_operateLog
for each row
begin
select Task_operateLog_id.nextval into :new.id from dual;
end;
/
CREATE INDEX Task_operateLog_Index_1 ON Task_operateLog (workdate)
/
CREATE INDEX Task_operateLog_Index_2 ON Task_operateLog (userid)
/
CREATE TABLE Task_read
	(
	id     integer NOT NULL,
	userid integer NULL,
	taskid integer NULL
	)
/
create sequence Task_read_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Task_read_id_trigger
before insert on Task_read
for each row
begin
select Task_read_id.nextval into :new.id from dual;
end;
/
CREATE INDEX Task_read_Index_1 ON Task_read (userid)
/
CREATE TABLE Task_schedule
	(
	id       integer NOT NULL,
	userid   integer NULL,
	taskid   integer NULL,
	tasktype integer NULL,
	taskdate CHAR (10) NULL
	)
/
create sequence Task_schedule_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Task_schedule_id_trigger
before insert on Task_schedule
for each row
begin
select Task_schedule_id.nextval into :new.id from dual;
end;
/
CREATE INDEX Task_schedule_Index_1 ON Task_schedule (taskid)
/
CREATE INDEX Task_schedule_Index_2 ON Task_schedule (userid)
/
CREATE TABLE TM_TaskFeedback
	(
	id         integer NOT NULL,
	taskid     integer NULL,
	content    varchar2(4000) NULL,
	hrmid      integer NULL,
	type       integer NULL,
	docids     varchar2(4000) NULL,
	wfids      varchar2(4000) NULL,
	meetingids varchar2(4000) NULL,
	crmids     varchar2(4000) NULL,
	projectids varchar2(4000) NULL,
	fileids    varchar2(4000) NULL,
	createdate CHAR (10) NULL,
	createtime CHAR (8) NULL
	)
/
create sequence TM_TaskFeedback_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger TM_TaskFeedback_id_trigger
before insert on TM_TaskFeedback
for each row
begin
select TM_TaskFeedback_id.nextval into :new.id from dual;
end;
/
CREATE INDEX TM_TF_Index_1 ON TM_TaskFeedback (id)
/
CREATE INDEX TM_TF_Index_2 ON TM_TaskFeedback (taskid)
/
CREATE INDEX TM_TF_Index_3 ON TM_TaskFeedback (hrmid)
/

CREATE TABLE TM_TaskInfo 
	(
	id          integer NOT NULL,
	name        varchar2(4000) NULL,
	status      integer NULL,
	typeid      integer NULL,
	tasklevel       integer NULL,
	remark      varchar2(4000) NULL,
	risk        varchar2(4000) NULL,
	difficulty  varchar2(4000) NULL,
	assist      varchar2(4000) NULL,
	tag         VARCHAR2 (100) NULL,
	arrangerid  integer NULL,
	principalid integer NULL,
	partnerids  varchar2(4000) NULL,
	begindate   CHAR (10) NULL,
	enddate     CHAR (10) NULL,
	parentid    integer NULL,
	taskids     varchar2(4000) NULL,
	docids      varchar2(4000) NULL,
	wfids       varchar2(4000) NULL,
	meetingids  varchar2(4000) NULL,
	crmids      varchar2(4000) NULL,
	projectids  varchar2(4000) NULL,
	alids     	varchar2(4000) NULL,
	planids     varchar2(4000) NULL,
	fileids     varchar2(4000) NULL,
	creater     integer NULL,
	createdate  CHAR(10) NULL,
	createtime  CHAR(8) NULL,
	updater     integer NULL,
	updatedate  CHAR(10) NULL,
	updatetime  CHAR(8) NULL,
	deleted     integer NULL
	)
/
create sequence TM_TaskInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger TM_TaskInfo_id_trigger
before insert on TM_TaskInfo
for each row
begin
select TM_TaskInfo_id.nextval into :new.id from dual;
end;
/
CREATE INDEX TM_TI_Index_1 ON TM_TaskInfo (id)
/
CREATE INDEX TM_TI_Index_2 ON TM_TaskInfo (arrangerid)
/
CREATE INDEX TM_TI_Index_3 ON TM_TaskInfo (principalid)
/
CREATE INDEX TM_TI_Index_4 ON TM_TaskInfo (parentid)
/
CREATE TABLE TM_TaskLog
	(
	id           integer NOT NULL,
	taskid       integer NULL,
	type         integer NULL,
	operator     integer NULL,
	operatedate  CHAR (10) NULL,
	operatetime  CHAR (8) NULL,
	operatefiled VARCHAR2 (50) NULL,
	operatevalue varchar2(4000) NULL
	)
/
create sequence TM_TaskLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger TM_TaskLog_id_trigger
before insert on TM_TaskLog
for each row
begin
select TM_TaskLog_id.nextval into :new.id from dual;
end;
/
CREATE INDEX TM_TL_Index_1 ON TM_TaskLog (id)
/
CREATE INDEX TM_TL_Index_2 ON TM_TaskLog (taskid)
/
CREATE TABLE TM_TaskPartner
	(
	id        integer NOT NULL,
	taskid    integer NULL,
	partnerid integer NULL
	)
/
create sequence TM_TaskPartner_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger TM_TaskPartner_id_trigger
before insert on TM_TaskPartner
for each row
begin
select TM_TaskPartner_id.nextval into :new.id from dual;
end;
/
CREATE INDEX TM_TP_Index_1 ON TM_TaskPartner (taskid)
/
CREATE TABLE TM_TaskSharer
	(
	id       integer NOT NULL,
	taskid   integer NULL,
	sharerid integer NULL
	)
/
create sequence TM_TaskSharer_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger TM_TaskSharer_id_trigger
before insert on TM_TaskSharer
for each row
begin
select TM_TaskSharer_id.nextval into :new.id from dual;
end;
/
CREATE INDEX TM_TS_Index_1 ON TM_TaskSharer (taskid)
/
CREATE TABLE TM_TaskSpecial
	(
	id     integer NOT NULL,
	taskid integer NULL,
	userid integer NULL
	)
/
create sequence TM_TaskSpecial_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger TM_TaskSpecial_id_trigger
before insert on TM_TaskSpecial
for each row
begin
select TM_TaskSpecial_id.nextval into :new.id from dual;
end;
/
CREATE INDEX TM_TSL_Index_1 ON TM_TaskSpecial (taskid)
/
CREATE INDEX TM_TSL_Index_2 ON TM_TaskSpecial (userid)
/
ALTER TABLE cowork_log ADD id integer 
/
create sequence cowork_log_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger cowork_log_id_trigger
before insert on cowork_log
for each row
begin
select cowork_log_id.nextval into :new.id from dual;
end;
/
update cowork_log set id=cowork_log_id.nextval
/
CREATE INDEX cowork_log_index_coworkid ON cowork_log (coworkid)
/
CREATE INDEX cowork_log_index_modifier ON cowork_log (modifier)
/
CREATE INDEX cowork_modifier_coworkid ON cowork_log (modifier,coworkid) 
/
CREATE INDEX cowork_read_index_userid ON cowork_read (userid)
/
CREATE INDEX cowork_read_index_coworkid ON cowork_read (coworkid)
/
CREATE INDEX cowork_hidden_index_userid ON cowork_hidden (userid)
/
CREATE INDEX cowork_hidden_index_coworkid ON cowork_hidden (coworkid)
/
CREATE INDEX coworkshare_index_sourceid ON coworkshare (sourceid)
/
UPDATE blog_AppItem SET face='/blog/images/mood-happy.png' WHERE id=1
/
UPDATE blog_AppItem SET face='/blog/images/mood-unhappy.png' WHERE id=2
/
create or replace trigger task_cowork_log after insert  or  delete on cowork_discuss for each row 
DECLARE  
var_userid integer;  
var_workdate CHAR(10); 
var_taskid integer; 
var_logid integer; 
begin    
if inserting then 
  BEGIN 
   var_userid:=:new.discussant; 
   var_workdate:=:new.createdate; 
   var_taskid:=:new.coworkid; 
   var_logid:=:new.id; 
   insert into task_operateLog(userid,workdate,tasktype,taskid,logid,createdate,createtime,logtype)  
   VALUES(var_userid,var_workdate,5,var_taskid,var_logid,to_char(sysdate,'yyyy-mm-dd'),to_char(sysdate,'hh24:mi:ss'),1); 
  END; 
end if; 
if deleting then  
   var_taskid:=:old.coworkid;  
   var_userid:=:old.discussant;  
   DELETE FROM task_operateLog WHERE userid=var_userid AND tasktype=5 AND taskid=var_taskid;  
end if;
end;      
/
create or replace trigger task_crm_log after insert  or  delete on WorkPlan for each row 
DECLARE  
var_userid integer;  
var_workdate CHAR(10); 
var_taskid integer; 
var_logid integer; 
begin    
if inserting then 
  BEGIN 
   var_userid:=:new.resourceid; 
   var_workdate:=:new.createdate; 
   var_taskid:=:new.crmid; 
   var_logid:=:new.id; 
   insert into task_operateLog(userid,workdate,tasktype,taskid,logid,createdate,createtime,logtype)  
   VALUES(var_userid,var_workdate,9,var_taskid,var_logid,to_char(sysdate,'yyyy-mm-dd'),to_char(sysdate,'hh24:mi:ss'),1); 
  END; 
end if; 
if deleting then  
   var_userid:=:old.resourceid;  
   var_taskid:=:old.crmid;  
   DELETE FROM task_operateLog WHERE userid=var_userid AND tasktype=9 AND taskid=var_taskid;  
end if;
end;     
/
create or replace trigger task_tm_log after insert  or  delete on TM_TaskFeedback for each row 
DECLARE  
var_userid integer;  
var_workdate CHAR(10); 
var_taskid integer; 
var_logid integer; 
begin    
if inserting then 
  BEGIN 
   var_userid:=:new.hrmid; 
   var_workdate:=:new.createdate; 
   var_taskid:=:new.taskid; 
   var_logid:=:new.id; 
   insert into task_operateLog(userid,workdate,tasktype,taskid,logid,createdate,createtime,logtype)  
   VALUES(var_userid,var_workdate,1,var_taskid,var_logid,to_char(sysdate,'yyyy-mm-dd'),to_char(sysdate,'hh24:mi:ss'),1); 
  END; 
end if; 
if deleting then  
   var_userid:=:old.hrmid;  
   var_taskid:=:old.taskid;  
   DELETE FROM task_operateLog WHERE userid=var_userid AND tasktype=1 AND taskid=var_taskid;  
end if;
end;   
/
create or replace trigger task_workflow_log
after insert  or  delete
on workflow_requestlog
for each row
DECLARE 
var_userid integer;
var_workdate CHAR(10);
var_taskid integer;
var_logid integer;
begin   
if inserting then
  BEGIN
   var_userid:=:new.operator;
   var_workdate:=:new.operatedate;
   var_taskid:=:new.requestid;
   var_logid:=:new.logid;
   insert into task_operateLog(userid,workdate,tasktype,taskid,logid,createdate,createtime,logtype) 
   VALUES(var_userid,var_workdate,2,var_taskid,var_logid,to_char(sysdate,'yyyy-mm-dd'),to_char(sysdate,'hh24:mi:ss'),1);
  END; 
end if;
if deleting then 
   var_taskid:=:old.requestid; 
   var_userid:=:old.operator; 
   DELETE FROM task_operateLog WHERE userid=var_userid AND tasktype=2 AND taskid=var_taskid; 
end if;
end;
/