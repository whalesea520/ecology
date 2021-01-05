CREATE TABLE exp_ftpdetail (
	id integer  NOT NULL,
	name varchar2(200) NULL , 
	adress varchar2(200) NULL , 
	port varchar2(20) NULL , 
	path varchar2(100) NULL, 
	ftpuser varchar2(100) NULL, 
    ftppwd  varchar2(100) NULL, 
	createdate varchar2(20), 
	creator int null
)
/
create sequence exp_ftpdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_ftpdetail_Tri
before insert on exp_ftpdetail
for each row
begin
select exp_ftpdetail_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_localdetail (
	id integer  NOT NULL,
	name varchar2(200) NULL ,
	path varchar2(100) NULL,
	createdate varchar2(20),
	creator int null
)
/
create sequence exp_localdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_localdetail_Tri
before insert on exp_localdetail
for each row
begin
select exp_localdetail_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_dbdetail(
	id integer  NOT NULL,
	name varchar2(200) NULL , 
	resoure varchar2(100) NULL ,
	maintable varchar2(100) NULL ,
	detailtable varchar2(100) NULL,
	createdate varchar2(20),
	creator int null
)
/
create sequence exp_dbdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_dbdetail_Tri
before insert on exp_dbdetail
for each row
begin
select exp_dbdetail_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_setting (
	id integer  NOT NULL,
	name varchar2(200) NULL ,
	expsavetype varchar2(100) NULL , 
	exptypeid int null,
	syntype char(1), 
	exprequest char(1),
	exprequestpath  varchar2(100) NULL,
	expremark  char(1),
	expremarkimage char(1),
	expremarkimagepath  varchar2(100) NULL,
	expfile char(1) NULL,
	expfiletozip char(1) NULL,
	expremarkfile char(1) NULL,
	expremarkfiletozip char(1) NULL,
	expfilepath varchar2(500)  NULL
)
/
create sequence exp_setting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_setting_Tri
before insert on exp_setting
for each row
begin
select exp_setting_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_xmlsetting (
	id integer  NOT NULL,
	expid int NULL,
	xmltype char(1),
	xmlencode char(1),
	xmlpathtype int ,
	xmlTemplate varchar2(4000) NULL
)
/
create sequence exp_xmlsetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_xmlsetting_Tri
before insert on exp_xmlsetting
for each row
begin
select exp_xmlsetting_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_dbsetting (
	id integer  NOT NULL,
	expid int null,
	dbid int NULL,
	maintable varchar2(200) NULL ,
	mainidtype  char(1) NULL,
	detailtable varchar2(200) NULL ,
	detailidtype char(1) NULL
)
/
create sequence exp_dbsetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_dbsetting_Tri
before insert on exp_dbsetting
for each row
begin
select exp_dbsetting_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_dbmaintablesetting  (
	id integer  NOT NULL,
	dbsettingid int null, 
	columnname varchar2(200) NULL ,
	columntype  varchar2(50) NULL ,
	primarykey  char(1) NULL,
	isdoce char(1) NULL,
	doctype  char(1) NULL,
	filename char(1) NULL
)
/
create sequence exp_dbmaintablesetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_dbmaintablesetting_Tri
before insert on exp_dbmaintablesetting
for each row
begin
select exp_dbmaintablesetting_id.nextval into :new.id from dual;
end;
/


CREATE TABLE exp_dbdetailtablesetting  (
    id integer  NOT NULL,
	dbsettingid int null,
	columnname varchar2(200) NULL ,
	columntype  varchar2(50) NULL ,
	primarykey  char(1) NULL,
	isdoce char(1) NULL,
	doctype  char(1) NULL,
	mainid char(1) NULL,
	filename char(1) NULL
	
)
/
create sequence exp_dbdetailtablesetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_dbdetailtablesetting_Tri
before insert on exp_dbdetailtablesetting
for each row
begin
select exp_dbdetailtablesetting_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_logdetail  (
	id integer  NOT NULL,
	requestname varchar2(2000) NULL , 
	requestid int NULL,
	workflowid int null,
	sender int NULL,
	senddate varchar2(10) NULL ,
	sendtime varchar2(10) NULL , 
	status char(1) NULL ,
	reason varchar2(400) NULL ,
	type char(1) NULL
)
/
create sequence exp_logdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_logdetail_Tri
before insert on exp_logdetail
for each row
begin
select exp_logdetail_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_workflowDetail  (
	id integer  NOT NULL,
	workflowid int null,
	workflowname varchar2(1000),
	workflowtype int null,
	expid int NULL, 
	createdate varchar2(20), 
	creator int null
)
/
create sequence exp_workflowDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_workflowDetail_Tri
before insert on exp_workflowDetail
for each row
begin
select exp_workflowDetail_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_ProList (
	id integer  NOT NULL,
	ProName varchar2(200) NULL ,
	Proid  int  not null, 
	ProType char(1),
	ProFileSaveType char(1)
)
/
create sequence exp_ProList_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_ProList_Tri
before insert on exp_ProList
for each row
begin
select exp_ProList_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_XMLProSettings (
	id integer  NOT NULL,
	name varchar2(200) not NULL ,
	FileSaveType  char(1) NULL , 
	regitType int,
	synType char(1),
	TimeModul char(1) NULL, 
	Frequency int NULL,
	frequencyy int NULL,
	createType char(1) NULL,
	createTime char(8) NULL,

	XMLType char(1) NULL,
	XMLEcodingType char(1) NULL, 
	XMLFileType char(1) NULL,
	XMLHaveRemark  char(1)  NULL,
	xmltext varchar2(4000) NULL,
	ExpWorkflowFileFlag  char(1)  NULL,
	ExpWorkflowFileForZipFlag  char(1)  NULL,
	ExpWorkflowRemarkFileFlag  char(1)  NULL,
	ExpWorkflowRemarkFileForZip  char(1)  NULL,
	ExpWorkflowFilePath  varchar2(500)  NULL,

	ExpWorkflowInfoFlag  char(1)  NULL,
	ExpWorkflowInfoPath varchar2(500)  NULL,
	ExpWorkflowRemarkFlag  char(1)  NULL,
	ExpSignFileFlag  char(1)  NULL,
	ExpSignFilePath  varchar2(500)  NULL

)
/
create sequence exp_XMLProSettings_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_XMLProSettings_Tri
before insert on exp_XMLProSettings
for each row
begin
select exp_XMLProSettings_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_DBProSettings (
	id integer  NOT NULL,
	name varchar2(200) not NULL , 
	FileSaveType  char(1) NULL ,
	regitType int,
	expTableType  char(1),
	synType char(1),
	TimeModul char(1) NULL, 
	Frequency int NULL, 
	frequencyy int NULL,
	createType char(1) NULL,
	createTime char(8) NULL,

	regitDBId int,
	mainTableKeyType char(1) NULL, 
	dtTableKeyType char(1) NULL, 

	ExpWorkflowFileFlag  char(1)  NULL,
	ExpWorkflowFileForZipFlag  char(1)  NULL,
	ExpWorkflowRemarkFileFlag  char(1)  NULL,
	ExpWorkflowRemarkFileForZip  char(1)  NULL,
	ExpWorkflowFilePath  varchar2(500)  NULL,

	ExpWorkflowInfoFlag  char(1)  NULL,
	ExpWorkflowInfoPath varchar2(500)  NULL,
	ExpWorkflowRemarkFlag  char(1)  NULL,
	ExpSignFileFlag  char(1)  NULL,
	ExpSignFilePath  varchar2(500)  NULL,

	zwMapFiletype  varchar2(200)  NULL, 
	fjMapFiletype  varchar2(200)  NULL,
	dwdMapFiletype  varchar2(200)  NULL,
	mwdMapFiletype  varchar2(200)  NULL,
	remarkWDMapFiletype  varchar2(200)  NULL,
	remarkFJMapFiletype  varchar2(200)  NULL, 
	bdMapFiletype  varchar2(200)  NULL
)
/
create sequence exp_DBProSettings_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_DBProSettings_Tri
before insert on exp_DBProSettings
for each row
begin
select exp_DBProSettings_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_workflowXML  (
	id integer  NOT NULL,
	rgworkflowid int null, 
	xmltext varchar2(4000) NULL
)
/
create sequence exp_workflowXML_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_workflowXML_Tri
before insert on exp_workflowXML
for each row
begin
select exp_workflowXML_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_workflowFieldXMLMap (
	id integer  NOT NULL,
	rgworkflowid int null, 
	fieldid int NULL,
	fieldhtmltype int NULL ,
	fieldtype  int  NULL,
	fieldName varchar2(200) NULL ,
	valueType char(1) NULL
)
/
create sequence exp_workflowFieldXMLMap_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_workflowFieldXMLMap_Tri
before insert on exp_workflowFieldXMLMap
for each row
begin
select exp_workflowFieldXMLMap_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_workflowFieldDBMap (
	id integer  NOT NULL,
	rgworkflowid int null,
	fieldid int NULL,
	fieldhtmltype int NULL ,
	fieldtype  int  NULL,
	fieldName varchar2(200) NULL ,
	valueType char(1) NULL,
	expfieldname varchar2(200), 
	expfieldtype varchar2(100),
	fileddbname varchar2(200)
	
)
/
create sequence exp_workflowFieldDBMap_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_workflowFieldDBMap_Tri
before insert on exp_workflowFieldDBMap
for each row
begin
select exp_workflowFieldDBMap_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_wfDBMainFixField (
	id integer  NOT NULL,
	rgworkflowid int null, 
	expfieldname varchar2(200), 
	expfieldtype varchar2(100),
	value varchar2(200),
	talbetype char(1)
)
/
create sequence exp_wfDBMainFixField_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_wfDBMainFixField_Tri
before insert on exp_wfDBMainFixField
for each row
begin
select exp_wfDBMainFixField_id.nextval into :new.id from dual;
end;
/

CREATE TABLE exp_FieldMap_cs (
	id integer  NOT NULL,
	rgworkflowid int null,
	fieldMapid int null,
	fieldvalue  varchar2(500)  NULL,
	convertvalue  varchar2(500)  NULL,
	protype  char(1)  NULL
	
)
/
create sequence exp_FieldMap_cs_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger exp_FieldMap_cs_Tri
before insert on exp_FieldMap_cs
for each row
begin
select exp_FieldMap_cs_id.nextval into :new.id from dual;
end;
/