create table mode_customsearch (
	id int IDENTITY(1,1) NOT NULL,
	modeid int,
	customname varchar(100),
	customdesc varchar(400)
)
go

CREATE TABLE mode_CustomDspField(
	id int IDENTITY(1,1) NOT NULL,
	customid int NULL,
	fieldid int NULL,
	isquery char(1)  NULL,
	isshow char(1)  NULL,
	showorder int null,
	queryorder int,
	istitle char(1)
)
go

create  PROCEDURE mode_CustomDspField_Init
(@reportid_1    int, @flag   int   output, @msg    varchar(80)   output) AS 
begin
	INSERT INTO mode_CustomDspField ( customid, fieldid, isquery, isshow,showorder,queryorder,istitle)
	VALUES ( @reportid_1, -2,'1','1',2,2,0) ;
	INSERT INTO mode_CustomDspField ( customid, fieldid, isquery, isshow,showorder,queryorder,istitle)
	VALUES ( @reportid_1, -1,'1','1',1,1,0) ;
end 
GO

create  PROCEDURE mode_CustomDspField_Insert
(@reportid_1    int, @fieldid_2   int,  @dborder_3     char(1) , @shows char(1), @compositororder  varchar(10),@queryorder int,@istitle int, @flag   int   output, @msg    varchar(80)   output) AS
INSERT INTO mode_CustomDspField ( customid, fieldid, isquery, isshow,showorder,queryorder,istitle) VALUES ( @reportid_1, @fieldid_2, @dborder_3, @shows, @compositororder,@queryorder,@istitle) 
GO

CREATE TABLE mode_report (
	id int IDENTITY (1, 1) NOT NULL ,
	reportname varchar(100)  NULL ,
	formId int null,
	modeid int,
	reportdesc varchar(4000),
	reportnumperpage int
)
GO

CREATE TABLE mode_ReportDspField (
	id int IDENTITY (1, 1) NOT NULL ,
	reportid int NULL ,
	fieldid int NULL ,
	dsporder numeric(10,2) NULL,
	isstat char (1)  NULL ,
	dborder char (1)  NULL,
    compositororder int,
    dbordertype char(1)	
)
GO

CREATE  INDEX mode_ReportDspField_report ON mode_ReportDspField (reportid) 
GO

create table mode_reportshareinfo(
	id					int IDENTITY(1,1) NOT NULL,	
	reportid			int,
	righttype			int,
	sharetype			int,	
	relatedid			int,
	rolelevel			int,
	showlevel			int
)
GO
create table mode_custombrowser (
	id int IDENTITY(1,1) NOT NULL,
	modeid int,
	customname varchar(100),
	customdesc varchar(400)
)
go

CREATE TABLE mode_CustombrowserDspField(
	id int IDENTITY(1,1) NOT NULL,
	customid int NULL,
	fieldid int NULL,
	isquery char(1)  NULL,
	isshow char(1)  NULL,
	showorder int null,
	queryorder int,
	istitle char(1)
)
go

create  PROCEDURE mode_C_BrowserDspField_Init
(@reportid_1    int, @flag   int   output, @msg    varchar(80)   output) AS 
begin
	INSERT INTO mode_CustomBrowserDspField ( customid, fieldid, isquery, isshow,showorder,queryorder,istitle)
	VALUES ( @reportid_1, -2,'1','1',2,2,0) ;
	INSERT INTO mode_CustomBrowserDspField ( customid, fieldid, isquery, isshow,showorder,queryorder,istitle)
	VALUES ( @reportid_1, -1,'1','1',1,1,0) ;
end 
GO

create  PROCEDURE mode_C_BrowserDspField_Insert
(@reportid_1    int, @fieldid_2   int,  @dborder_3     char(1) , @shows char(1), @compositororder  varchar(10),@queryorder int,@istitle int, @flag   int   output, @msg    varchar(80)   output) AS
INSERT INTO mode_CustomBrowserDspField ( customid, fieldid, isquery, isshow,showorder,queryorder,istitle) VALUES ( @reportid_1, @fieldid_2, @dborder_3, @shows, @compositororder,@queryorder,@istitle) 
GO



alter table modeinfo add custompage varchar(200)
go
create table mode_triggerworkflowset(
	id int identity,
	modeid int,
	workflowid int,
	wfcreater int,
	wfcreaterfieldid int
)
go
create table mode_triggerworkflowsetdetail(
	id int identity,
	mainid int,
	modefieldid int,
	wffieldid int
)
go

create table mode_workflowtomodeset(
	id int identity,
	modeid int,
	workflowid int,
	modecreater int,
	modecreaterfieldid int,
	triggerNodeId int,
	triggerType int
)
go
create table mode_workflowtomodesetdetail(
	id int identity,
	mainid int,
	modefieldid int,
	wffieldid int
)
go