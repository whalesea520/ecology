ALTER table workflow_base add version integer
/
ALTER table workflow_base add activeVersionID integer
/
ALTER table workflow_base add versionDescription varchar2(255)
/
ALTER table workflow_base add VersionCreater integer
/

create table workflow_versionNodeRelation (
	nodeid integer,
	parentNodeid integer
)
/

ALTER TABLE Workflow_ReportDspField ADD fieldwidth DECIMAL(10, 2)
/
ALTER TABLE Workflow_ReportDspField ADD reportcondition INTEGER
/
ALTER TABLE Workflow_ReportDspField ADD httype VARCHAR2 (10)
/
ALTER TABLE Workflow_ReportDspField ADD htdetailtype VARCHAR2 (10)
/
ALTER TABLE Workflow_ReportDspField ADD valuefour VARCHAR2 (255)
/
ALTER TABLE Workflow_ReportDspField ADD valueone VARCHAR2 (255)
/
ALTER TABLE Workflow_ReportDspField ADD valuethree VARCHAR2 (255)
/
ALTER TABLE Workflow_ReportDspField ADD valuetwo VARCHAR2 (255)
/
ALTER TABLE WorkflowReportShare rename column userid to useridbak 
/
ALTER TABLE WorkflowReportShare rename column departmentid to departmentidbak 
/
ALTER TABLE WorkflowReportShare rename column subcompanyid to  subcompanyidbak 
/
ALTER TABLE WorkflowReportShare rename column roleid to roleidbak 
/
ALTER TABLE WorkflowReportShare rename column seclevel to seclevelbak
/
ALTER TABLE WorkflowReportShare ADD userid VARCHAR2 (255)
/
ALTER TABLE WorkflowReportShare ADD departmentid VARCHAR2 (255)
/
ALTER TABLE WorkflowReportShare ADD subcompanyid VARCHAR2 (255)
/
ALTER TABLE WorkflowReportShare ADD roleid VARCHAR2 (255)
/
ALTER TABLE WorkflowReportShare ADD seclevel INTEGER
/
UPDATE WorkflowReportShare SET userid = useridbak,departmentid = departmentidbak,subcompanyid =subcompanyidbak,roleid = roleidbak,seclevel = seclevelbak
/

CREATE VIEW view_workflowForm_selectAll 
  AS
	select id,formname,formdesc,subcompanyid,0 as isoldornew from workflow_formbase 
	union all
	select t1.id,indexdesc,formdes,subcompanyid,1 as isoldornew from workflow_bill t1,HtmlLabelIndex t2 where t1.namelabel=t2.id
/

alter table datashowset add name varchar2(200)
/

create table rule_base(
	id int NOT NULL,
	rulesrc int NULL,
	formid int NULL,
	linkid int NULL,
	isbill int NULL,
	rulename varchar2(500) NULL,
	ruledesc varchar2(1000) NULL,
	condit varchar2(2000) NULL
)
/
create sequence rule_base_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger rule_base_id_trigger
before insert on rule_base
for each row 
begin
select rule_base_id.nextval into :new.id from dual;
end;
/
create table rule_expressionbase(
	id int NOT NULL,
	ruleid int NULL,
	datafield int NULL,
	datafieldtext varchar2(200) NULL,
	compareoption1 int NULL,
	compareoption2 int NULL,
	htmltype int NULL,
	typehrm int NULL,
	fieldtype varchar2(10) NULL,
	valuetype int NULL,
	paramtype int NULL,
	elementvalue1 varchar2(1000) NULL,
	elementlabel1 varchar2(1000) NULL,
	elementvalue2 varchar2(1000) NULL
)
/
create table rule_expressions(
	id int NOT NULL,
	ruleid int NULL,
	relation int NULL,
	expids varchar2(1000) NULL,
	expbaseid int NULL
)
/

create table wfnodegeneralmode(
	id int  NOT NULL,
	modename varchar(200) NULL,
	formid int NULL,
	isbill int NULL,
	wfid int NULL,
	nodeid int NULL
)
/
create sequence wfnodegeneralmode_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger wfnodegeneralmode_id_trigger
before insert on wfnodegeneralmode
for each row 
begin
select wfnodegeneralmode_id.nextval into :new.id from dual;
end;
/

alter table workflow_base add dsporder integer
/
update workflow_base set dsporder = 0 where dsporder is null or dsporder = ''
/