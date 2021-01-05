CREATE TABLE ofs_setting(
	IsUse	number NOT NULL,
	OAShortName	varchar2(20) NULL,
	OAFullName	varchar2(20) NULL,
	ShowSysName	varchar2(10) NULL,
	ShowDone	number NULL,
	RemindIM	number NULL,
	RemindApp	number NULL,
	Modifier	number NULL,
	ModifyDate  varchar2(10) NULL,
	ModifyTime  varchar2(10)
)
/

CREATE TABLE ofs_sysinfo(
  sysid  number PRIMARY KEY NOT NULL,
  syscode  varchar2(100) NULL,
  SysShortName  varchar2(100) NULL,
  SysFullName  varchar2(100) NULL,
  Pcprefixurl  varchar2(200) NULL,
  Appprefixurl  varchar2(200) NULL,
  autoCreateWfType  number NULL,
  editWfType  number NULL,
  receiveWfData  number NULL,
  HrmTransRule  varchar2(10) NULL,
  Cancel  number NULL,
  creator  number NULL,
  createdate  varchar2(10) NULL,
  createtime  varchar2(10) NULL,
  Modifier  number NULL,
  ModifyDate  varchar2(10) NULL,
  ModifyTime  varchar2(10)
)
/

create sequence ofs_sysinfo_id
start with -1
increment by -1
nomaxvalue
nocycle
/

create or replace trigger ofs_sysinfo_Tri
before insert on ofs_sysinfo
for each row
begin
select ofs_sysinfo_id.nextval into :new.sysid from dual;
end;
/

CREATE TABLE ofs_workflow(
  workflowid  number PRIMARY KEY NOT NULL,
  sysid  number NULL,
  workflowname  varchar2(100) NULL,
  receiveWfData  number NULL,
  Cancel  number NULL,
  creator  number NULL,
  createdate  varchar2(10) NULL,
  createtime  varchar2(10) NULL,
  Modifier  number NULL,
  ModifyDate  Varchar2(10) NULL,
  ModifyTime  Varchar2(10) NULL
)
/

create sequence ofs_workflow_id
start with -1
increment by -1
nomaxvalue
nocycle
/

create or replace trigger ofs_workflow_Tri
before insert on ofs_workflow
for each row
begin
select ofs_workflow_id.nextval into :new.workflowid from dual;
end;
/

CREATE TABLE ofs_log(
  logid  number PRIMARY KEY NOT NULL,
  sysid  number NULL,
  dataType  varchar2(10) NULL,
  operType  varchar2(10) NULL,
  operResult  number NULL,
  failRemark  varchar2(1000) NULL,
  syscode  varchar2(100) NULL,
  flowid varchar2(100),
  requestname  varchar2(200) NULL,
  workflowname  varchar2(100) NULL,
  nodename  varchar2(100) NULL,
  isremark  number NULL,
  pcurl  varchar2(2000) NULL,
  appurl  varchar2(2000) NULL,
  creator  varchar2(50) NULL,
  creatorid  number NULL,
  createdate  varchar2(10) NULL,
  createtime  varchar2(10) NULL,
  receiver  varchar2(50) NULL,
  userid  number NULL,
  receivedate  varchar2(10) NULL,
  receivetime  varchar2(10) NULL
)
/

create sequence ofs_log_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger ofs_log_Tri
before insert on ofs_log
for each row
begin
select ofs_log_id.nextval into :new.logid from dual;
end;
/

CREATE TABLE ofs_todo_data(
  id  number PRIMARY KEY NOT NULL,
  syscode  varchar2(100) NULL,
  sysid  number NULL,
  flowid varchar2(100),
  flowguid  varchar2(300) NULL,
  requestid  number NULL,
  requestname  varchar2(200) NULL,
  workflowname  varchar2(100) NULL,
  workflowid  number NULL,
  isremark  char(1) NULL,
  nodename  varchar2(100) NULL,
  viewtype  number NULL,
  islasttimes  number NULL,
  iscomplete  number NULL,
  pcurl  varchar2(2000) NULL,
  appurl  varchar2(2000) NULL,
  creator  varchar2(50) NULL,
  creatorid  number NULL,
  createdate  varchar2(10) NULL,
  createtime  varchar2(10) NULL,
  receiver  varchar2(50) NULL,
  userid  number NULL,
  receivedate  varchar2(10) NULL,
  receivetime  varchar2(10) NULL,
  operatedate  varchar2(10) NULL,
  operatetime  varchar2(8) NULL
)
/

create sequence ofs_todo_data_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger ofs_todo_data_Tri
before insert on ofs_todo_data
for each row
begin
select ofs_todo_data_id.nextval into :new.id from dual;
end;
/
ALTER TABLE ofs_setting MODIFY OAShortName varchar2(50) 
/
ALTER TABLE ofs_setting MODIFY OAFullName varchar2(100) 
/

insert into ofs_setting(IsUse,OAShortName,OAFullName,ShowSysName,ShowDone,RemindIM,RemindApp)values(0,'泛微OA','泛微协同办公平台',0,0,0,0)
/