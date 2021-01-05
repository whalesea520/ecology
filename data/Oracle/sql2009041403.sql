delete from workflow_codeSet where id in(15,16,17,18)
/
insert into workflow_codeSet(id,showName,showType) values(15,22755,'5')
/
insert into workflow_codeSet(id,showName,showType) values(16,22753,'5')
/
insert into workflow_codeSet(id,showName,showType) values(17,141,'5')
/
insert into workflow_codeSet(id,showName,showType) values(18,124,'5')
/

update  workflow_CodeDetail set  showId=22755 where showId=261
/

alter table workflow_Code add struSeqAlone char(1) 
/
alter table workflow_Code add struSeqSelect char(1) 
/


CREATE TABLE workflow_supSubComAbbr (
	id int  not null,
	workflowId int null ,
	formId int null ,
	isBill char(1) null ,
	fieldId int null ,
	fieldValue int null ,
	abbr varchar2(100) null 
)
/
create sequence workflow_supSubComAbbr_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_supSubComAbbr_Tri
before insert on workflow_supSubComAbbr
for each row
begin
select workflow_supSubComAbbr_id.nextval into :new.id from dual;
end;
/

CREATE TABLE workflow_subComAbbr (
	id int  not null,
	workflowId int null ,
	formId int null ,
	isBill char(1) null ,
	fieldId int null ,
	fieldValue int null ,
	abbr varchar2(100) null 
)
/
create sequence workflow_subComAbbr_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_subComAbbr_Tri
before insert on workflow_subComAbbr
for each row
begin
select workflow_subComAbbr_id.nextval into :new.id from dual;
end;
/

CREATE TABLE workflow_deptAbbr (
	id int  not null,
	workflowId int null ,
	formId int null ,
	isBill char(1) null ,
	fieldId int null ,
	fieldValue int null ,
	abbr varchar2(100) null 
)
/
create sequence workflow_deptAbbr_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_deptAbbr_Tri
before insert on workflow_deptAbbr
for each row
begin
select workflow_deptAbbr_id.nextval into :new.id from dual;
end;
/

CREATE TABLE workflow_subComAbbrDef (
	id int  not null,
	subCompanyId int null ,
	abbr varchar2(100) null 
)
/
create sequence workflow_subComAbbrDef_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_subComAbbrDef_Tri
before insert on workflow_subComAbbrDef
for each row
begin
select workflow_subComAbbrDef_id.nextval into :new.id from dual;
end;
/

CREATE TABLE workflow_deptAbbrDef (
	id int  not null,
	departmentId int null ,
	abbr varchar2(100) null 
)
/
create sequence workflow_deptAbbrDef_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_deptAbbrDef_Tri
before insert on workflow_deptAbbrDef
for each row
begin
select workflow_deptAbbrDef_id.nextval into :new.id from dual;
end;
/

CREATE TABLE workflow_codeSeqReserved (
	id int  not null,
	codeSeqId int null ,
	reservedId int null ,
	reservedDesc varchar2(200) null ,
	hasUsed int  default 0 null,
	hasDeleted int  default 0 null
)
/
create sequence workflow_codeSeqReserved_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_codeSeqReserved_Tri
before insert on workflow_codeSeqReserved
for each row
begin
select workflow_codeSeqReserved_id.nextval into :new.id from dual;
end;
/




alter table workflow_codeseq add supSubCompanyId int default -1
/
alter table workflow_codeseq add subCompanyId int default -1
/
update workflow_codeseq set supSubCompanyId=-1
/
update workflow_codeseq set subCompanyId=-1
/

CREATE TABLE Workflow_FieldYear (
	id integer  not null,
	yearId integer null ,
	yearName varchar2(20) null ,
	yearDesc varchar2(100) null
)
/
create sequence Workflow_FieldYear_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Workflow_FieldYear_Tri
before insert on Workflow_FieldYear
for each row
begin
select Workflow_FieldYear_id.nextval into :new.id from dual;
end;
/

CREATE TABLE workflow_codeSeqRecord (
	id integer  not null,
	requestId integer null ,
	codeSeqId integer null ,
	sequenceId integer null ,
	codeSeqReservedId integer null ,
	workflowCode varchar2(100) null
)
/
create sequence workflow_codeSeqRecord_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_codeSeqRecord_Tri
before insert on workflow_codeSeqRecord
for each row
begin
select workflow_codeSeqRecord_id.nextval into :new.id from dual;
end;
/

delete from Workflow_FieldYear where yearId>=2007 and yearId<=2011
/
insert into Workflow_FieldYear(yearId,yearName,yearDesc) values(2007,'2007','')
/
insert into Workflow_FieldYear(yearId,yearName,yearDesc) values(2008,'2008','')
/
insert into Workflow_FieldYear(yearId,yearName,yearDesc) values(2009,'2009','')
/
insert into Workflow_FieldYear(yearId,yearName,yearDesc) values(2010,'2010','')
/
insert into Workflow_FieldYear(yearId,yearName,yearDesc) values(2011,'2011','')
/

delete from workflow_browserurl where id=178
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 178,15933,'int','/systeminfo/BrowserMain.jsp?url=/workflow/field/Workflow_FieldYearBrowser.jsp','Workflow_FieldYear','yearName','yearId','')
/


update workflow_codeSet set showType='5' where showName in(445,6076,390)
/
update workflow_codeDetail set codeValue='-2' where showId in(445,6076,390) and codeValue='1'
/


alter table workflow_codeSeqReserved add reservedCode varchar2(200)
/
