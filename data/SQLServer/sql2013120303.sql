alter table outter_sys add requesttype char(1)
GO
alter table outter_sys add urlparaencrypt1 char(1)
GO
alter table outter_sys add encryptcode1 varchar(100)
GO
alter table outter_sys add urlparaencrypt2 char(1)
GO
alter table outter_sys add encryptcode2 varchar(100)
GO
alter table outter_sys add urlparaencrypt char(1)
GO
alter table outter_sys add encryptcode varchar(100)
GO
alter table outter_sys add encrypttype char(1)
GO
alter table outter_sys add encryptclass varchar(100)
GO
alter table outter_sys add encryptmethod varchar(100)
GO

alter table outter_sysparam add paraencrypt char(1)
GO
alter table outter_sysparam add encryptcode varchar(100)
GO

create table ldapset
(
	id int IDENTITY (1, 1) NOT NULL ,
	isuseldap char(1),
	ldaptype char(10),
	ldapserverurl varchar(1000),
	ldaparea varchar(2000),
	ldapuser varchar(100),
	ldappasswd varchar(100),
	ldapcondition varchar(1000),
	TimeModul char(1),
	Frequency int,
	frequencyy int,
	createType char(1),
	createTime char(8),
	factoryclass varchar(200),
	isUac char(1),
	uacValue varchar(200),
	ldaplogin varchar(200)
)
GO

create table ldapsetparam
(
	id int IDENTITY (1, 1) NOT NULL ,
	ldapattr varchar(100),
	userattr varchar(100)
)
GO
create table HrmLdapPlanCheck
(
       cycle varchar(20),
       planDate varchar(50)
)
GO
create table hrm_synts
(
	id int,
	synts varchar(20),
	descstr varchar(200)
)
GO

insert into hrm_synts(id,synts,descstr) values(1,'1970-01-01 00:00:00','同步分部')
GO
insert into hrm_synts(id,synts,descstr) values(2,'1970-01-01 00:00:00','同步部门')
GO
insert into hrm_synts(id,synts,descstr) values(3,'1970-01-01 00:00:00','同步岗位')
GO
insert into hrm_synts(id,synts,descstr) values(4,'1970-01-01 00:00:00','同步人员')
GO

create table hrsyncset
(
	id int IDENTITY (1, 1) NOT NULL ,
	isuselhr char(1),
	intetype char(1),
	dbsource varchar(100),
	webserviceurl varchar(500),
	invoketype char(1),
	customparams varchar(500),
	custominterface varchar(500),
	hrmethod char(1),
	TimeModul char(1),
	Frequency int,
	frequencyy int,
	createType char(1),
	createTime char(8),
	jobtable  varchar(100),
	depttable  varchar(100),
	subcomtable  varchar(100),
	hrmtable varchar(100),
	jobmothod varchar(100),
	deptmothod varchar(100),
	subcommothod varchar(100),
	hrmmethod varchar(100),
)
GO

create table hrsyncsetparam
(
	id int IDENTITY (1, 1) NOT NULL ,
	type char(1),
	oafield varchar(100),
	outfield varchar(100),
	iskeyfield char(1),
	isnewfield char(1)
)
GO

alter table outerdatawfset add datarecordtype char(1)
GO
alter table outerdatawfset ADD keyfield varchar(100)
GO
alter table outerdatawfset ADD requestid varchar(100)
GO
alter table outerdatawfset ADD FTriggerFlag varchar(100)
GO
alter table outerdatawfset ADD FTriggerFlagValue varchar(100)
GO
alter table outerdatawfsetdetail add customsql varchar(2000)
GO

update outerdatawfset set keyfield='id'
GO
update outerdatawfset set datarecordtype='2'
GO
update outerdatawfset set requestid='requestid'
GO
update outerdatawfset set FTriggerFlag='FTriggerFlag'
GO
update outerdatawfset set FTriggerFlagValue='1'
GO
alter table outerdatawfset add typename char(1)
GO
create table outerdatawfdetail
(
       mainid int,
       workflowid int,
       requestid int,
       keyfieldvalue varchar(1000),
       FTriggerFlag char(1)
)
GO
create table financeset
(
  id int IDENTITY (1, 1) NOT NULL ,
  isenable int,
  financename varchar(200),
  financetype char(1),
  interfacetype char(1),
  datasourceid varchar(100),
  custominfo varchar(1000),
  custominterface varchar(1000),
  workFlowId int,
  triggermothod char(1),
  triggerNodeId int,
  triggerType char(1),
  triggerlinkId int

)
GO
create table financesetparam
(
	id int IDENTITY (1, 1) NOT NULL ,
        mainset int,
	type char(1),
	financefield varchar(1000),
	workflowfield char(1),
	formfield int,
	customfieldvalue varchar(1000),
	valuestat int,
	fieldname varchar(1000),
	groupCount int,
	fieldHtmlType int,
	fieldType int,
	valuecode int
)
GO


alter table workflow_addinoperate add wftofinancesetid int
GO
alter table hrsyncset add jobparam varchar(2000)
GO
alter table hrsyncset add deptparam varchar(2000)
GO
alter table hrsyncset add subcomparam varchar(2000)
GO
alter table hrsyncset add hrmparam varchar(2000)
GO


alter table wsactionset add webservicefrom varchar(500)
GO
alter table wsactionset add custominterface varchar(500)
GO


create table datasearchparam
(
	id int IDENTITY (1, 1) NOT NULL ,
        mainid int,
	fieldname varchar(100),
	searchname varchar(100),
	fieldtype char(1)
)
GO
create table datashowparam
(
	id int IDENTITY (1, 1) NOT NULL ,
        mainid int,
	fieldname varchar(100),
	searchname varchar(100),
	transql varchar(1000)
)
GO

alter table hrmsubcompany add outkey varchar(100)
GO
alter table hrmdepartment add outkey varchar(100)
GO
alter table hrmjobtitles add outkey varchar(100)
GO
alter table hrmresource add outkey varchar(100)
GO
alter table hrsyncsetparam add isparentfield char(1)
GO
alter table hrsyncsetparam add issubcomfield char(1)
GO
alter table hrsyncsetparam add isdeptfield char(1)
GO
alter table hrsyncsetparam add ishrmdeptfield char(1)
GO
alter table hrsyncsetparam add ishrmjobfield char(1)
GO
alter table hrsyncsetparam add transql varchar(1000)
GO
create table HrmPlanCheck
(
	id int IDENTITY (1, 1) NOT NULL ,
	type varchar(100),
	cycle varchar(100),
	planDate varchar(100)
)
GO
alter table dmlactionset add typename char(1)
GO
alter table wsactionset add typename char(1)
GO