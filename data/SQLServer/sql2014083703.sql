create table ModeFormFieldExtend(
	formId int,
	fieldId int,
	needlog int,
	isprompt int
)
go

create table ModeLogFieldDetail(
	id int primary key identity(1,1),
	viewlogid int,
	fieldid int,
	fieldvalue varchar(4000),
	prefieldvalue varchar(4000)
)
go
create table ModeFormExtend(
	formid int,
	appid int,
	isvirtualform varchar(2),
	virtualformtype varchar(2),
	vdatasource varchar(50),
	vprimarykey varchar(50),
	vpkgentype varchar(2)
)
go
CREATE TABLE mobileAppBaseInfo(
	id int IDENTITY(1,1) NOT NULL,
	appname varchar(256),
	picpath varchar(1024),
	descriptions varchar(256),
	showorder int,
	isdelete int,
	formId int,
	ispublish int,
	modelid int
	CONSTRAINT PK_mobileAppBaseInfo PRIMARY KEY (id)
)
GO
CREATE TABLE mobileAppModelInfo(
	id int IDENTITY(1,1) NOT NULL,
	appId int,
	formId int,
	isdelete int,
	entityName varchar(128),
	modelid int,
	showorder int
	CONSTRAINT PK_mobileAppModelInfo PRIMARY KEY (id)
)
GO
CREATE TABLE AppFormUI(
	id int IDENTITY(1,1) NOT NULL,
	formid int,
	uiContent text,
	uiType int,
	appid int,
	uiname varchar(256),
	isdelete int,
	uiTemplate text,
	defaultTitle varchar(256),
	entityId int
	CONSTRAINT PK_AppFormUI PRIMARY KEY (id)
)
GO
CREATE TABLE AppFieldUI(
	id int IDENTITY(1,1) NOT NULL,
	formid int,
	appid int,
	fieldid int,
	uiparam varchar(512),
	showtype int,
	formuiid int,
	comptype int
	CONSTRAINT PK_AppFieldUI PRIMARY KEY (id)
)
GO
create table FormModeLog(
	objid varchar(50),
	logmodule varchar(20),
	logtype varchar(10),
	operator varchar(50),
	operatorname varchar(50),
	optdatetime varchar(50),
	optdatetime2 varchar(50)
)
go
create table MobileExtendComponent(
	id varchar(50) primary key,
	objid varchar(50),
	objtype varchar(10),
	mectype varchar(50),
	mecparam varchar(4000)
)
go
CREATE TABLE AppHomepage(
	id int IDENTITY(1,1) NOT NULL,
	appid int,
	formuiids varchar(1024),
	pagecontent text,
	mobiledeviceid int,
	parentid int,
	pagename varchar(256),
	pagedesc varchar(256),
	ishomepage int
	CONSTRAINT PK_AppHomepage PRIMARY KEY (id)
)
GO
create table mobiledevice(
	id int identity(1,1) not null,
	devicename varchar(256),
	picpath varchar(1024),
	width int,
	height int,
	defaultenable int
	CONSTRAINT PK_mobiledevice PRIMARY KEY (id)
)
GO
create table appdatacount
(
	id int IDENTITY(1,1) NOT NULL,
	appid int,
	[month] varchar(8),
	sumval int  
)
GO
CREATE TABLE customfieldshowchange(
	id int IDENTITY(1,1) NOT NULL,
	customid int,
	fieldid int,
	fieldopt int,
	fieldoptvalue varchar(10),
	fieldshowvalue text,
	fieldbackvalue text,
	fieldfontvalue text
	CONSTRAINT PK_customfieldshowchange PRIMARY KEY (id)
)
go
ALTER TABLE mode_customsearch ADD searchconditiontype VARCHAR(10)
go
ALTER TABLE mode_customsearch ADD javafilename VARCHAR(100)
go
ALTER TABLE mode_custombrowser ADD searchconditiontype VARCHAR(10)
go
ALTER TABLE mode_custombrowser ADD javafilename VARCHAR(100)
go
create index FormModeLog_objid_logmodule on FormModeLog (objid, logmodule)
go
alter table FormModeLog add id int identity(1,1) primary key;
go
alter table mode_custompage add appid int
go
alter table mode_customtree add appid int
go
ALTER TABLE MobileAppBaseInfo ADD publishid VARCHAR(50)
go
alter table MobileExtendComponent add tempcol ntext
go
update MobileExtendComponent set tempcol = mecparam
go
EXEC sp_rename 'MobileExtendComponent.[mecparam]','mecparam_temp','COLUMN' 
go
EXEC sp_rename 'MobileExtendComponent.[tempcol]','mecparam','COLUMN'
go
alter table MobileExtendComponent drop column mecparam_temp
go
alter table mode_CustomDspField add isstat char(1)
go
alter table mode_customsearch add pagenumber int
go
alter table mode_custombrowser add pagenumber int
go
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl)
 VALUES ( 256,33578,'','/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/CustomTreeBrowser.jsp','','','','')
GO
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl)
 VALUES ( 257,33579,'','/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/CustomTreeBrowser.jsp','','','','')
GO
alter table mode_custombrowserDspField add isquicksearch int
go
alter table datashowset add customid int
go
alter table AppFormUI add sourceid int
go
alter table AppFormUI add mobiledeviceid int
go
alter table AppFormUI add parentid int
go
insert into mobiledevice values('iPhone','/mobilemode/images/toolbar/iphone.png',346,619,1)
GO
insert into mobiledevice values('iPad','/mobilemode/images/toolbar/monitor.png',862,572,0)
GO
alter table mode_customsearch add formid int
go
alter table mode_customsearch add appid int
go
alter table mode_custombrowser add formid int
go
alter table mode_custombrowser add appid int
go
alter table mode_Report add appid int
go
alter table modeTreeField add isdelete int
go
alter table modeinfo add dsporder float
go
alter table mode_customsearch add dsporder float
go
alter table mode_Report add dsporder float
go
alter table mode_custombrowser add dsporder float
go
alter table workflow_bill add dsporder float
go
INSERT INTO mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) VALUES('清空条件','2','3','0','0','','1','8','1','8','清空条件','0','1')
GO
INSERT INTO mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) SELECT id,'清空条件','2','3','0','0','','1','8','1','8','清空条件','0','1' FROM modeinfo
GO
alter table mode_CustomDspField add iskey int 
go
insert into mode_pageexpandtemplate values('日志',2,3,0,0,'',1,8.00,1,9,'日志',0,0);
go
alter table mode_CustomDspField add isorderfield int,priorder char(4) 
go
alter table Mode_CustomDspField add hreflink varchar(1000)
go
alter table Mode_CustomDspField add showmethod int
go
alter table customfieldshowchange add fieldoptvalue2 varchar(10)
go
alter table customfieldshowchange add fieldopt2 int
go
alter table customfieldshowchange alter column fieldoptvalue varchar(30)
go
alter table customfieldshowchange alter column fieldoptvalue2 varchar(30)
go
alter table mode_ReportDspField add isshow char(1)
GO
alter table mode_CustombrowserDspField add isorderfield int,priorder char(4) 
GO
alter table ModeLogFieldDetail add modeid int default 0 
go
alter table customfieldshowchange add singlevalue int
go
alter table customfieldshowchange add morevalue int
go
alter table mode_customsearch add detailtable varchar(60);
GO

