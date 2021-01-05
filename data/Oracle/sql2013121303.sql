alter table outter_sys add requesttype char(1)
/
alter table outter_sys add urlparaencrypt1 char(1)
/
alter table outter_sys add encryptcode1 varchar2(100)
/
alter table outter_sys add urlparaencrypt2 char(1)
/
alter table outter_sys add encryptcode2 varchar2(100)
/
alter table outter_sys add urlparaencrypt char(1) 
/
alter table outter_sys add encryptcode varchar2(100) 
/
alter table outter_sys add encrypttype char(1) 
/
alter table outter_sys add encryptclass varchar2(100) 
/
alter table outter_sys add encryptmethod varchar2(100) 
/
alter table outter_sysparam add paraencrypt char(1) 
/
alter table outter_sysparam add encryptcode varchar2(100) 
/

create table ldapset
(
	ID NUMBER(*,0) primary key NOT NULL ENABLE,
	isuseldap char(1),
	ldaptype char(10),
	ldapserverurl varchar2(1000),
	ldaparea varchar2(2000),
	ldapuser varchar2(100),
	ldappasswd varchar2(100),
	ldapcondition varchar2(1000),
	TimeModul char(1),
	Frequency int,
	frequencyy int,
	createType char(1),
	createTime char(8),
	factoryclass varchar2(200),
	isUac char(1),
	uacValue varchar2(200),
	ldaplogin varchar2(200)
)
/

CREATE SEQUENCE ldapset_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger ldapset_Tri
  before insert on ldapset
  for each row
begin
  select ldapset_seq.nextval into :new.id from dual;
end;
/
create table ldapsetparam
(
	ID NUMBER(*,0) primary key NOT NULL ENABLE,
	ldapattr varchar2(100),
	userattr varchar2(100)
)
/
CREATE SEQUENCE ldapsetparam_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/

create or replace trigger ldapsetparam_Tri
  before insert on ldapsetparam
  for each row
begin
  select ldapsetparam_seq.nextval into :new.id from dual;
end;
/

create table HrmLdapPlanCheck
(
       cycle varchar2(20),
       planDate varchar2(50)
)
/

create table hrm_synts
(
	id int,
	synts varchar2(20),
	descstr varchar2(200)
)
/

insert into hrm_synts(id,synts,descstr) values(1,'1970-01-01 00:00:00','同步分部') 
/
insert into hrm_synts(id,synts,descstr) values(2,'1970-01-01 00:00:00','同步部门') 
/
insert into hrm_synts(id,synts,descstr) values(3,'1970-01-01 00:00:00','同步岗位') 
/
insert into hrm_synts(id,synts,descstr) values(4,'1970-01-01 00:00:00','同步人员') 
/

create table hrsyncset
(
	ID NUMBER(*,0) primary key NOT NULL ENABLE,
	isuselhr char(1),
	intetype char(1),
	dbsource varchar2(100),
	webserviceurl varchar2(500),
	invoketype char(1),
	customparams varchar2(500),
	custominterface varchar2(500),
	hrmethod char(1),
	TimeModul char(1),
	Frequency int,
	frequencyy int,
	createType char(1),
	createTime char(8),
	jobtable  varchar2(100),
	depttable  varchar2(100),
	subcomtable  varchar2(100),
	hrmtable varchar2(100),
	jobmothod varchar2(100),
	deptmothod varchar2(100),
	subcommothod varchar2(100),
	hrmmethod varchar2(100)
)
/

CREATE SEQUENCE hrsyncset_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/

create or replace trigger hrsyncset_Tri
  before insert on hrsyncset
  for each row
begin
  select hrsyncset_seq.nextval into :new.id from dual;
end;
/

create table hrsyncsetparam
(
	ID NUMBER(*,0) primary key NOT NULL ENABLE,
	type char(1),
	oafield varchar2(100),
	outfield varchar2(100),
	iskeyfield char(1),
	isnewfield char(1)
) 
/

CREATE SEQUENCE hrsyncsetparam_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/

create or replace trigger hrsyncsetparam_Tri
  before insert on hrsyncsetparam
  for each row
begin
  select hrsyncsetparam_seq.nextval into :new.id from dual;
end;
/

alter table outerdatawfset add datarecordtype char(1) 
/
alter table outerdatawfset ADD keyfield varchar2(100) 
/
alter table outerdatawfset ADD requestid varchar2(100) 
/
alter table outerdatawfset ADD FTriggerFlag varchar2(100) 
/
alter table outerdatawfset ADD FTriggerFlagValue varchar2(100) 
/
alter table outerdatawfsetdetail add customsql varchar2(2000) 
/
update outerdatawfset set keyfield='id' 
/
update outerdatawfset set datarecordtype='2' 
/
update outerdatawfset set requestid='requestid' 
/
update outerdatawfset set FTriggerFlag='FTriggerFlag' 
/
update outerdatawfset set FTriggerFlagValue='1' 
/
alter table outerdatawfset add typename char(1) 
/
create table outerdatawfdetail
(
       mainid int,
       workflowid int,
       requestid int,
       keyfieldvalue varchar2(1000),
       FTriggerFlag char(1)
) 
/
create table financeset
(
  ID NUMBER(*,0) primary key NOT NULL ENABLE,
  isenable int,
  financename varchar2(200),
  financetype char(1),
  interfacetype char(1),
  datasourceid varchar2(100),
  custominfo varchar2(1000),
  custominterface varchar2(1000),
  workFlowId int,
  triggermothod char(1),
  triggerNodeId int,
  triggerType char(1),
  triggerlinkId int

) 
/
CREATE SEQUENCE financeset_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger financeset_Tri
  before insert on financeset
  for each row
begin
  select financeset_seq.nextval into :new.id from dual;
end;
/
create table financesetparam
(
	ID NUMBER(*,0) primary key NOT NULL ENABLE,
  mainset int,
	type char(1),
	financefield varchar2(1000),
	workflowfield char(1),
	formfield int,
	customfieldvalue varchar2(1000),
	valuestat int,
	fieldname varchar2(1000),
	groupCount int,
	fieldHtmlType int,
	fieldType int,
	valuecode int
) 
/
CREATE SEQUENCE financesetparam_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger financesetparam_Tri
  before insert on financesetparam
  for each row
begin
  select financesetparam_seq.nextval into :new.id from dual;
end;
/

alter table workflow_addinoperate add wftofinancesetid int 
/
alter table hrsyncset add jobparam varchar2(2000) 
/
alter table hrsyncset add deptparam varchar2(2000) 
/
alter table hrsyncset add subcomparam varchar2(2000) 
/
alter table hrsyncset add hrmparam varchar2(2000) 
/


alter table wsactionset add webservicefrom varchar2(500) 
/
alter table wsactionset add custominterface varchar2(500) 
/
delete from HtmlLabelIndex where id=27922  
/
delete from HtmlLabelInfo where indexid=27922  
/
INSERT INTO HtmlLabelIndex values(27922,'执行WebService接口/自定义接口后获得返回值，直接与设置的返回值做比较。如果相同，则表示执行成功')  
/
INSERT INTO HtmlLabelInfo VALUES(27922,'执行WebService接口/自定义接口后获得返回值，直接与设置的返回值做比较。如果相同，则表示执行成功',7)  
/
INSERT INTO HtmlLabelInfo VALUES(27922,'Return value from WebService or custom interface is a string.',8)  
/
INSERT INTO HtmlLabelInfo VALUES(27922,'執行WebService接口/自定義接口後獲得返回值，直接與設置的返回值做比較。如果相同，則表示執行成功',9)  
/
delete from HtmlLabelIndex where id=27923  
/
delete from HtmlLabelInfo where indexid=27923  
/
INSERT INTO HtmlLabelIndex values(27923,'执行WebService接口/自定义接口后获得返回值，直接替换下方设置的SQL语句中的返回值标签，并执行该SQL')  
/
INSERT INTO HtmlLabelInfo VALUES(27923,'执行WebService接口/自定义接口后获得返回值，直接替换下方设置的SQL语句中的返回值标签，并执行该SQL',7)  
/
INSERT INTO HtmlLabelInfo VALUES(27923,'Return value from WebService or custom interface will be executed as a sql.',8)  
/
INSERT INTO HtmlLabelInfo VALUES(27923,'執行WebService接口/自定義接口後獲得返回值，直接替換下方設置的SQL語句中的返回值标簽，并執行該SQL',9)  
/
create table datasearchparam
(
	ID NUMBER(*,0) primary key NOT NULL ENABLE,
  mainid int,
	fieldname varchar2(100),
	searchname varchar2(100),
	fieldtype char(1)
) 
/
CREATE SEQUENCE datasearchparam_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger datasearchparam_Tri
  before insert on datasearchparam
  for each row
begin
  select datasearchparam_seq.nextval into :new.id from dual;
end;
/
create table datashowparam
(
	ID NUMBER(*,0) primary key NOT NULL ENABLE,
  mainid int,
	fieldname varchar2(100),
	searchname varchar2(100),
	transql varchar2(1000)
) 
/
CREATE SEQUENCE datashowparam_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger datashowparam_Tri
  before insert on datashowparam
  for each row
begin
  select datashowparam_seq.nextval into :new.id from dual;
end;
/
alter table hrmsubcompany add outkey varchar2(100) 
/
alter table hrmdepartment add outkey varchar2(100) 
/
alter table hrmjobtitles add outkey varchar2(100) 
/
alter table hrmresource add outkey varchar2(100) 
/
alter table hrsyncsetparam add isparentfield char(1) 
/
alter table hrsyncsetparam add issubcomfield char(1) 
/
alter table hrsyncsetparam add isdeptfield char(1) 
/
alter table hrsyncsetparam add ishrmdeptfield char(1) 
/
alter table hrsyncsetparam add ishrmjobfield char(1) 
/
alter table hrsyncsetparam add transql varchar2(1000) 
/
create table HrmPlanCheck
(
	ID NUMBER(*,0) primary key NOT NULL ENABLE,
	type varchar2(100),
	cycle varchar2(100),
	planDate varchar2(100)
) 
/
CREATE SEQUENCE HrmPlanCheck_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger HrmPlanCheck_Tri
  before insert on HrmPlanCheck
  for each row
begin
  select HrmPlanCheck_seq.nextval into :new.id from dual;
end;
/
alter table dmlactionset add typename char(1) 
/
alter table wsactionset add typename char(1) 
/