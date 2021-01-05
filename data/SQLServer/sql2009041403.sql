
delete from workflow_codeSet where id in(15,16,17,18)
GO
insert into workflow_codeSet(id,showName,showType) values(15,22755,'5')
GO
insert into workflow_codeSet(id,showName,showType) values(16,22753,'5')
GO
insert into workflow_codeSet(id,showName,showType) values(17,141,'5')
GO
insert into workflow_codeSet(id,showName,showType) values(18,124,'5')
GO

update  workflow_CodeDetail set  showId=22755 where showId=261
GO

alter table workflow_Code add struSeqAlone char(1) 
GO
alter table workflow_Code add struSeqSelect char(1) 
GO


CREATE TABLE workflow_supSubComAbbr (
	id int identity (1, 1) not null,
	workflowId int null ,
	formId int null ,
	isBill char(1) null ,
	fieldId int null ,
	fieldValue int null ,
	abbr varchar(100) null 
)
GO
CREATE TABLE workflow_subComAbbr (
	id int identity (1, 1) not null,
	workflowId int null ,
	formId int null ,
	isBill char(1) null ,
	fieldId int null ,
	fieldValue int null ,
	abbr varchar(100) null 
)
GO
CREATE TABLE workflow_deptAbbr (
	id int identity (1, 1) not null,
	workflowId int null ,
	formId int null ,
	isBill char(1) null ,
	fieldId int null ,
	fieldValue int null ,
	abbr varchar(100) null 
)
GO
CREATE TABLE workflow_subComAbbrDef (
	id int identity (1, 1) not null,
	subCompanyId int null ,
	abbr varchar(100) null 
)
GO
CREATE TABLE workflow_deptAbbrDef (
	id int identity (1, 1) not null,
	departmentId int null ,
	abbr varchar(100) null 
)
GO
CREATE TABLE workflow_codeSeqReserved (
	id int identity (1, 1) not null,
	codeSeqId int null ,
	reservedId int null ,
	reservedDesc varchar(200) null ,
	hasUsed int  default 0 null,
	hasDeleted int  default 0 null
)
GO

alter table workflow_codeseq add supSubCompanyId int default -1
GO
alter table workflow_codeseq add subCompanyId int default -1
GO
update workflow_codeseq set supSubCompanyId=-1
GO
update workflow_codeseq set subCompanyId=-1
GO

CREATE TABLE Workflow_FieldYear (
	id int identity (1, 1) not null,
	yearId int null ,
	yearName varchar(20) null ,
	yearDesc varchar(100) null
)
GO

CREATE TABLE workflow_codeSeqRecord (
	id int identity (1, 1) not null,
	requestId int null ,
	codeSeqId int null ,
	sequenceId int null ,
	codeSeqReservedId int null ,
	workflowCode varchar(100) null
)
GO

delete from Workflow_FieldYear where yearId>=2007 and yearId<=2011
GO
insert into Workflow_FieldYear(yearId,yearName,yearDesc) values(2007,'2007','')
GO
insert into Workflow_FieldYear(yearId,yearName,yearDesc) values(2008,'2008','')
GO
insert into Workflow_FieldYear(yearId,yearName,yearDesc) values(2009,'2009','')
GO
insert into Workflow_FieldYear(yearId,yearName,yearDesc) values(2010,'2010','')
GO
insert into Workflow_FieldYear(yearId,yearName,yearDesc) values(2011,'2011','')
GO

delete from workflow_browserurl where id=178
GO
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 178,15933,'int','/systeminfo/BrowserMain.jsp?url=/workflow/field/Workflow_FieldYearBrowser.jsp','Workflow_FieldYear','yearName','yearId','')
GO

update workflow_codeSet set showType='5' where showName in(445,6076,390)
GO
update workflow_codeDetail set codeValue='-2' where showId in(445,6076,390) and codeValue='1'
GO

alter table workflow_codeSeqReserved add reservedCode varchar(200)
GO
