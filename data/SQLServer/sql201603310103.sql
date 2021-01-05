CREATE TABLE ofs_setting(
	IsUse	int NOT NULL,
	OAShortName	varchar(20) NULL,
	OAFullName	varchar(20) NULL,
	ShowSysName	varchar(10) NULL,
	ShowDone	int NULL,
	RemindIM	int NULL,
	RemindApp	int NULL,
	Modifier	int NULL,
	ModifyDate	varchar(10) NULL,
	ModifyTime	varchar(10) NULL
)
GO

CREATE TABLE ofs_sysinfo(
	sysid	int IDENTITY(-1,-1) PRIMARY KEY NOT NULL,
	syscode	varchar(100) NULL,
	SysShortName	varchar(100) NULL,
	SysFullName	varchar(100) NULL,
	Pcprefixurl	varchar(200) NULL,
	Appprefixurl	varchar(200) NULL,
	autoCreateWfType	int NULL,
	editWfType	int NULL,
	receiveWfData	int NULL,
	HrmTransRule	varchar(10) NULL,
	Cancel	int NULL,
	creator	int NULL,
	createdate	varchar(10) NULL,
	createtime	varchar(10) NULL,
	Modifier	int NULL,
	ModifyDate	varchar(10) NULL,
	ModifyTime	varchar(10) NULL
)
GO

create table ofs_workflow(
	workflowid	int IDENTITY(-101,-1) PRIMARY KEY NOT NULL,
	sysid	int NULL,
	workflowname	varchar(100) NULL,
	receiveWfData	int NULL,
	Cancel	int NULL,
	creator	int NULL,
	createdate	varchar(10) NULL,
	createtime	varchar(10) NULL,
	Modifier	int NULL,
	ModifyDate	varchar(10) NULL,
	ModifyTime	varchar(10) NULL
)
GO

CREATE TABLE ofs_log(
	logid int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	sysid  int NULL,
	dataType  varchar(10) NULL,
	operType  varchar(10) NULL,
	operResult  int NULL,
	failRemark  varchar(1000) NULL,
	syscode  varchar(100) NULL,
	flowid varchar(100),
	requestname  varchar(200) NULL,
	workflowname  varchar(100) NULL,
	nodename  varchar(100) NULL,
	isremark  int NULL,
	pcurl  varchar(2000) NULL,
	appurl  varchar(2000) NULL,
	creator  varchar(50) NULL,
	creatorid  int NULL,
	createdate  varchar(10) NULL,
	createtime  varchar(10) NULL,
	receiver  varchar(50) NULL,
	userid  int NULL,
	receivedate  varchar(10) NULL,
	receivetime  varchar(10) NULL
)
GO

CREATE TABLE ofs_todo_data(
	id	int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	syscode	varchar(100) NULL,
	sysid	int NULL,
	flowid varchar(100),
	flowguid  varchar(300) NULL,
	requestid  int NULL,
	requestname	varchar(200) NULL,
	workflowname	varchar(100) NULL,
	workflowid	int NULL,
	isremark	char(1) NULL,
	nodename	varchar(100) NULL,
	viewtype	int NULL,
	islasttimes	int NULL,
	iscomplete	int NULL,
	pcurl	varchar(2000) NULL,
	appurl	varchar(2000) NULL,
	creator  varchar(50) NULL,
	creatorid  int NULL,
	createdate	varchar(10) NULL,
	createtime	varchar(10) NULL,
	receiver	varchar(50) NULL,
	userid	int NULL,
	receivedate	varchar(10) NULL,
	receivetime	varchar(10) NULL,
	operatedate	varchar(10) NULL,
	operatetime	varchar(8) NULL
)
GO

ALTER TABLE ofs_setting ALTER COLUMN OAShortName varchar(50) 
GO
ALTER TABLE ofs_setting ALTER COLUMN OAFullName varchar(100) 
GO

insert into ofs_setting(IsUse,OAShortName,OAFullName,ShowSysName,ShowDone,RemindIM,RemindApp)values(0,'泛微OA','泛微协同办公平台',0,0,0,0)
GO