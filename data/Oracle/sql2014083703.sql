create table ModeFormFieldExtend(
	formId int,
	fieldId int,
	needlog int,
	isprompt int
)
/
create table ModeLogFieldDetail(
	id int primary key,
	viewlogid int,
	fieldid int,
	fieldvalue varchar2(4000),
	prefieldvalue varchar2(4000)
)
/
create sequence ModeLogFieldDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger ModeLogFieldDetail_id_Tri
before insert on ModeLogFieldDetail
for each row
begin
select ModeLogFieldDetail_id.nextval into :new.id from dual;
end;
/
create table ModeFormExtend(
	formid int,
	appid int,
	isvirtualform varchar2(2),
	virtualformtype varchar2(2),
	vdatasource varchar2(50),
	vprimarykey varchar2(50),
	vpkgentype varchar2(2)
)
/
create table FormModeLog(
	id int primary key,
	objid varchar2(50),
	logmodule varchar2(20),
	logtype varchar2(10),
	operator varchar2(50),
	operatorname varchar2(50),
	optdatetime varchar2(50),
	optdatetime2 varchar2(50)
)
/
create table MobileExtendComponent(
	id varchar2(50) primary key,
	objid varchar2(50),
	objtype varchar2(10),
	mectype varchar2(50),
	mecparam nclob
)
/
CREATE TABLE mobileAppBaseInfo(
	id integer NOT NULL,
	appname varchar2(256),
	picpath varchar2(1024),
	descriptions varchar2(256),
	showorder integer,
	isdelete integer,
	formId integer,
	ispublish integer,
	modelid integer
)
/
CREATE TABLE mobileAppModelInfo(
	id integer NOT NULL,
	appId integer,
	formId integer,
	isdelete integer,
	entityName varchar2(128),
	modelid integer,
	showorder integer
)
/
CREATE TABLE AppFormUI(
	id int NOT NULL,
	formid integer,
	uiContent clob,
	uiType integer,
	appid integer,
	uiname varchar2(256),
	isdelete integer,
	uiTemplate clob,
	defaultTitle varchar2(256),
	entityId integer
)
/
CREATE TABLE AppFieldUI(
	id integer NOT NULL,
	formid integer,
	appid integer,
	fieldid integer,
	uiparam varchar2(512),
	showtype integer,
	formuiid integer,
	comptype integer
)
/
CREATE TABLE AppHomepage(
	id int NOT NULL,
	appid integer,
	formuiids varchar2(1024),
	pagecontent clob,
	mobiledeviceid int,
	parentid int,
	pagename varchar2(256),
	pagedesc varchar2(256),
	ishomepage int
)
/
CREATE TABLE mobiledevice(
	id int not null,
	devicename varchar2(256),
	picpath varchar2(1024),
	width int,
	height int,
	defaultenable int
)
/
create table appdatacount
(
	id int NOT NULL,
	appid int,
	month varchar(8),
	sumval int  
)
/
create sequence appdatacount_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger appdatacount_Tri
before insert on appdatacount
for each row
begin
select appdatacount_id.nextval into :new.id from dual;
end;
/
CREATE TABLE customfieldshowchange(
	id integer  NOT NULL,
	customid integer,
	fieldid integer,
	fieldopt integer,
	fieldoptvalue varchar2(10),
	fieldshowvalue clob,
	fieldbackvalue clob,
	fieldfontvalue clob,
	CONSTRAINT PK_customfieldshowchange PRIMARY KEY (id)
)
/
ALTER TABLE mode_customsearch ADD searchconditiontype VARCHAR2(10)
/
ALTER TABLE mode_customsearch ADD javafilename VARCHAR2(100)
/
ALTER TABLE mode_custombrowser ADD searchconditiontype VARCHAR2(10)
/
ALTER TABLE mode_custombrowser ADD javafilename VARCHAR2(100)
/
create index FormModeLog_objid_logmodule on FormModeLog (objid, logmodule)
/
create sequence FormModeLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FormModeLog_id_Tri
before insert on FormModeLog
for each row
begin
select FormModeLog_id.nextval into :new.id from dual;
end;
/
alter table mode_custompage add appid int
/
alter table mode_customtree add appid int
/
ALTER TABLE MobileAppBaseInfo ADD publishid VARCHAR2(50)
/
alter table mode_CustomDspField add isstat char(1)
/
alter table mode_customsearch add pagenumber int
/
alter table mode_custombrowser add pagenumber int
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl)
 VALUES ( 256,33578,'','/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/CustomTreeBrowser.jsp','','','','')
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl)
 VALUES ( 257,33579,'','/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/CustomTreeBrowser.jsp','','','','')
/
alter table mode_custombrowserDspField add isquicksearch int
/
alter table datashowset add customid int
/
create sequence mobileAppBaseInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mobileAppBaseInfo_Tri
before insert on mobileAppBaseInfo
for each row
begin
select mobileAppBaseInfo_id.nextval into :new.id from dual;
end;
/
create sequence mobileAppModelInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mobileAppModelInfo_Tri
before insert on mobileAppModelInfo
for each row
begin
select mobileAppModelInfo_id.nextval into :new.id from dual;
end;
/

create sequence AppFormUI_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger AppFormUI_Tri
before insert on AppFormUI
for each row
begin
select AppFormUI_id.nextval into :new.id from dual;
end;
/
create sequence AppFieldUI_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger AppFieldUI_Tri
before insert on AppFieldUI
for each row
begin
select AppFieldUI_id.nextval into :new.id from dual;
end;
/
alter table AppFormUI add sourceid int
/
alter table AppFormUI add mobiledeviceid int
/
alter table AppFormUI add parentid int
/
create sequence AppHomepage_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger AppHomepage_Tri
before insert on AppHomepage
for each row
begin
select AppHomepage_id.nextval into :new.id from dual;
end;
/
create sequence mobiledevice_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mobiledevice_Tri
before insert on mobiledevice
for each row
begin
select mobiledevice_id.nextval into :new.id from dual;
end;
/
insert into mobiledevice(devicename,picpath,width,height,defaultenable) values('iPhone','/mobilemode/images/toolbar/iphone.png',346,619,1)
/
insert into mobiledevice(devicename,picpath,width,height,defaultenable) values('iPad','/mobilemode/images/toolbar/monitor.png',862,572,0)
/
alter table mode_customsearch add formid int
/
alter table mode_customsearch add appid int
/
alter table mode_custombrowser add formid int
/
alter table mode_custombrowser add appid int
/
alter table mode_Report add appid int
/
alter table modeTreeField add isdelete int
/
alter table modeinfo add dsporder float
/
alter table mode_customsearch add dsporder float
/
alter table mode_Report add dsporder float
/
alter table mode_custombrowser add dsporder float
/
alter table workflow_bill add dsporder float
/
INSERT INTO mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) VALUES('清空条件','2','3','0','0','','1','8','1','8','清空条件','0','1')
/
INSERT INTO mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) SELECT id,'清空条件','2','3','0','0','','1','8','1','8','清空条件','0','1' FROM modeinfo
/
alter table mode_CustomDspField add iskey int 
/
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('日志','2','3','0','0','','1','8','1','9','日志','0','0')
/
alter table mode_CustomDspField add isorderfield int
/
alter table mode_CustomDspField add priorder char(4) 
/
alter table Mode_CustomDspField add hreflink varchar2(1000)
/

create sequence customfieldshowchange_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger customfieldshowchange_Tri
before insert on customfieldshowchange
for each row
begin
select customfieldshowchange_id.nextval into :new.id from dual;
end;
/
alter table Mode_CustomDspField add showmethod integer
/
alter table customfieldshowchange add fieldoptvalue2 varchar2(10)
/
alter table customfieldshowchange add fieldopt2 integer
/
alter table customfieldshowchange modify  fieldoptvalue varchar2(30)
/
alter table customfieldshowchange modify fieldoptvalue2 varchar2(30)
/
alter table mode_ReportDspField add isshow char(1)
/
alter table mode_CustombrowserDspField add isorderfield int 
/
alter table mode_CustombrowserDspField add priorder char(4) 
/
alter table ModeLogFieldDetail add modeid int default 0 
/
alter table customfieldshowchange add singlevalue int
/
alter table customfieldshowchange add morevalue int
/
alter table mode_customsearch add detailtable varchar2(60)
/