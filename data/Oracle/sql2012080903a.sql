create table mode_customsearch (
	id integer NOT NULL,
	modeid integer,
	customname varchar2(100),
	customdesc varchar2(400)
)
/

create sequence mode_customsearch_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_customsearch_Tri
before insert on mode_customsearch
for each row
begin
select mode_customsearch_id.nextval into :new.id from dual;
end;
/

CREATE TABLE mode_CustomDspField(
	id integer NOT NULL,
	customid integer NULL,
	fieldid integer NULL,
	isquery char(1)  NULL,
	isshow char(1)  NULL,
	showorder integer null,
	queryorder integer,
	istitle char(1)
)
/
create sequence mode_CustomDspField_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_CustomDspField_Tri
before insert on mode_CustomDspField
for each row
begin
select mode_CustomDspField_id.nextval into :new.id from dual;
end;
/

create or replace PROCEDURE mode_CustomDspField_Init
(@reportid_1    integer, @flag   integer   output, @msg    varchar2(80)   output) AS 
begin
	INSERT INTO mode_CustomDspField ( customid, fieldid, isquery, isshow,showorder,queryorder,istitle)
	VALUES ( @reportid_1, -2,'1','1',2,2,0) ;
	INSERT INTO mode_CustomDspField ( customid, fieldid, isquery, isshow,showorder,queryorder,istitle)
	VALUES ( @reportid_1, -1,'1','1',1,1,0) ;
end 
/

create or replace PROCEDURE mode_CustomDspField_Insert
(@reportid_1    integer, @fieldid_2   integer,  @dborder_3     char(1) , @shows char(1), @compositororder  varchar2(10),@queryorder integer,@istitle integer, @flag   integer   output, @msg    varchar2(80)   output) AS
INSERT INTO mode_CustomDspField ( customid, fieldid, isquery, isshow,showorder,queryorder,istitle) VALUES ( @reportid_1, @fieldid_2, @dborder_3, @shows, @compositororder,@queryorder,@istitle) 
/

CREATE TABLE mode_report (
	id integer NOT NULL ,
  reportname varchar2(100)  NULL ,
  formId integer null,
  modeid integer,
  reportdesc varchar2(4000),
  reportnumperpage integer
)
/

create sequence mode_report_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_report_Tri
before insert on mode_report
for each row
begin
select mode_report_id.nextval into :new.id from dual;
end;
/

CREATE TABLE mode_ReportDspField (
  id integer NOT NULL ,
  reportid integer NULL ,
  fieldid integer NULL ,
  dsporder numeric(10,2) NULL,
  isstat char (1)  NULL ,
  dborder char (1)  NULL,
    compositororder integer,
    dbordertype char(1)  
)
/
create sequence mode_ReportDspField_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_ReportDspField_Tri
before insert on mode_ReportDspField
for each row
begin
select mode_ReportDspField_id.nextval into :new.id from dual;
end;
/

CREATE  INDEX mode_ReportDspField_report ON mode_ReportDspField (reportid) 
/

create table mode_reportshareinfo(
  id          integer NOT NULL,  
  reportid      integer,
  righttype      integer,
  sharetype      integer,  
  relatedid      integer,
  rolelevel      integer,
  showlevel      integer
)
/
create sequence mode_reportshareinfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_reportshareinfo_Tri
before insert on mode_reportshareinfo
for each row
begin
select mode_reportshareinfo_id.nextval into :new.id from dual;
end;
/

create table mode_custombrowser (
  id integer NOT NULL,
  modeid integer,
  customname varchar2(100),
  customdesc varchar2(400)
)
/
create sequence mode_custombrowser_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_custombrowser_Tri
before insert on mode_custombrowser
for each row
begin
select mode_custombrowser_id.nextval into :new.id from dual;
end;
/

CREATE TABLE mode_CustombrowserDspField(
  id integer NOT NULL,
  customid integer NULL,
  fieldid integer NULL,
  isquery char(1)  NULL,
  isshow char(1)  NULL,
  showorder integer null,
  queryorder integer,
  istitle char(1)
)
/
create sequence mode_CustombrowserDspField_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_CustombrowserDspField_Tri
before insert on mode_CustombrowserDspField
for each row
begin
select mode_CustombrowserDspField_id.nextval into :new.id from dual;
end;
/

create table mode_triggerworkflowset(
  id integer not null,
  modeid integer,
  workflowid integer,
  wfcreater integer,
  wfcreaterfieldid integer
)
/
create sequence mode_triggerworkflowset_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_triggerworkflowset_Tri
before insert on mode_triggerworkflowset
for each row
begin
select mode_triggerworkflowset_id.nextval into :new.id from dual;
end;
/

create table mode_workflowtomodeset(
  id integer not null,
  modeid integer,
  workflowid integer,
  modecreater integer,
  modecreaterfieldid integer,
  triggerNodeId integer,
  triggerType integer
)
/
create sequence mode_workflowtomodeset_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_workflowtomodeset_Tri
before insert on mode_workflowtomodeset
for each row
begin
select mode_workflowtomodeset_id.nextval into :new.id from dual;
end;
/

alter table modeinfo add custompage varchar2(200)
/

create or replace PROCEDURE mode_C_BrowserDspField_Init
(@reportid_1    integer, @flag   integer   output, @msg    varchar2(80)   output) AS 
begin
  INSERT INTO mode_CustomBrowserDspField ( customid, fieldid, isquery, isshow,showorder,queryorder,istitle)
  VALUES ( @reportid_1, -2,'1','1',2,2,0) ;
  INSERT INTO mode_CustomBrowserDspField ( customid, fieldid, isquery, isshow,showorder,queryorder,istitle)
  VALUES ( @reportid_1, -1,'1','1',1,1,0) ;
end 
/

create or replace PROCEDURE mode_C_BrowserDspField_Insert
(@reportid_1    integer, @fieldid_2   integer,  @dborder_3     char(1) , @shows char(1), @compositororder  varchar2(10),@queryorder integer,@istitle integer, @flag   integer   output, @msg    varchar2(80)   output) AS
INSERT INTO mode_CustomBrowserDspField ( customid, fieldid, isquery, isshow,showorder,queryorder,istitle) VALUES ( @reportid_1, @fieldid_2, @dborder_3, @shows, @compositororder,@queryorder,@istitle) 
/

create table mode_triggerworkflowsetdetail(
  id integer not null,
  mainid integer,
  modefieldid integer,
  wffieldid integer
)
/
create sequence mode_t_workflowsetdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_t_workflowsetdetail_Tri
before insert on mode_triggerworkflowsetdetail
for each row
begin
select mode_t_workflowsetdetail_id_id.nextval into :new.id from dual;
end;
/

create table mode_workflowtomodesetdetail(
  id integer not null,
  mainid integer,
  modefieldid integer,
  wffieldid integer
)
/
create sequence mode_w_tomodesetdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_w_tomodesetdetail_Tri
before insert on mode_workflowtomodesetdetail
for each row
begin
select mode_w_tomodesetdetail_id.nextval into :new.id from dual;
end;
/