create table WorkflowToFinanceUrl(
  id integer primary key  NOT NULL,
  guid1 varchar2(50),
  sendUrl varchar2(4000),

  requestid integer,
  requestids blob,
  fnaVoucherXmlId integer,
  
  xmlSend blob,
  xmlReceive blob, 
  
  xmlObjSend blob,
  xmlObjReceive blob, 
  
  createDate char(10),
  createTime char(8)
)
/

create sequence seq_WorkflowToFinanceUrl_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create index idx_WorkflowToFinanceUrl_1 on WorkflowToFinanceUrl (guid1)
/

create index idx_WorkflowToFinanceUrl_2 on WorkflowToFinanceUrl (requestid)
/

create table FnaCreateXmlSqlLog(
  id integer primary key  NOT NULL,
  guid1 varchar2(50),
  exeSql blob
)
/

create sequence seq_FnaCreateXmlSqlLog_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create index idx_FnaCreateXmlSqlLog_1 on FnaCreateXmlSqlLog (guid1)
/

create table fnaVoucherXml(
  id integer primary key  NOT NULL,
  xmlName char(100),
  xmlMemo varchar2(4000),
  
  xmlVersion char(10),
  xmlEncoding char(50)
)
/

create sequence seq_fnaVoucherXml_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create index idx_fnaVoucherXml_1 on fnaVoucherXml (xmlName)
/

create table fnaVoucherXmlContent(
  id integer primary key  NOT NULL,
  fnaVoucherXmlId integer, 
  
  contentType char(1), 
  contentParentId integer, 
  
  contentName varchar2(100),
  contentValue blob, 
  
  parameter blob, 
  
  contentValueType char(1), 
  
  contentMemo varchar2(4000),

  orderId decimal(5,2) 
)
/

create sequence seq_fnaVoucherXmlContent_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create index idx_fnaVoucherXmlContent_1 on fnaVoucherXmlContent (fnaVoucherXmlId)
/

create index idx_fnaVoucherXmlContent_2 on fnaVoucherXmlContent (contentType)
/

create index idx_fnaVoucherXmlContent_3 on fnaVoucherXmlContent (contentParentId)
/

create index idx_fnaVoucherXmlContent_4 on fnaVoucherXmlContent (contentValueType)
/

create index idx_fnaVoucherXmlContent_5 on fnaVoucherXmlContent (orderId)
/

create table fnaVoucherXmlContentDset(
  id integer primary key  NOT NULL,
  fnaVoucherXmlId integer, 
  fnaVoucherXmlContentId integer, 
  dSetAlias varchar2(200),

  initTiming integer,
  
  fnaDataSetId integer,
  
  parameter blob, 
  
  dsetMemo varchar2(4000),
  
  orderId decimal(5,2)
)
/

create sequence seq_fVXmlContentDset_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create index idx_fVXmlContentDset_1 on fnaVoucherXmlContentDset (fnaVoucherXmlContentId)
/

create index idx_fVXmlContentDset_2 on fnaVoucherXmlContentDset (fnaDataSetId)
/

create index idx_fVXmlContentDset_3 on fnaVoucherXmlContentDset (orderId)
/

create table fnaDataSet(
  id integer primary key NOT NULL,
  dSetName char(100),
  
  dataSourceName char(50),
  
  dsMemo varchar2(4000),
    
  dSetType char(1), 
  dSetStr blob  
)
/

create sequence seq_fnaDataSet_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create index idx_fnaDataSet_1 on fnaDataSet (dSetName)
/

create index idx_fnaDataSet_2 on fnaDataSet (dataSourceName)
/

create index idx_fnaDataSet_3 on fnaDataSet (dSetType)
/


alter table Workflow_Report add fnaVoucherXmlId integer
/

alter table financeset add urlAddress VARCHAR2(4000)
/

alter table financeset add fnaVoucherXmlId integer
/

alter table fnaDataSet add fnaVoucherXmlId integer 
/

alter table fnaVoucherXml add workflowid integer
/

alter table fnaVoucherXmlContent add isNullNotPrint integer
/

alter table fnaVoucherXml add typename VARCHAR2(50)
/

alter table fnaVoucherXml add datasourceid VARCHAR2(500)
/


create table fnaFinancesetting(
  guid1 CHAR(32) PRIMARY KEY, 
  fnaVoucherXmlId integer, 
  fieldName VARCHAR2(100), 
  fieldValueType1 CHAR(20), 
  fieldValueType2 CHAR(20), 
  fieldValue VARCHAR2(4000),
  fieldDbTbName CHAR(100), 
  detailTable integer, 
  fieldDbName CHAR(100), 
  fieldDbType CHAR(20) 
)
/

create index idx_fnaFinancesetting_2 on fnaFinancesetting (fnaVoucherXmlId)
/


create or replace trigger WorkflowToFinanceUrl_trigger 
before insert 
on WorkflowToFinanceUrl 
for each row 
begin 
	select seq_WorkflowToFinanceUrl_id.nextval into :new.id from dual; 
end;
/

create or replace trigger fVXmlContentDset_trigger 
before insert 
on fnaVoucherXmlContentDset 
for each row 
begin 
	select seq_fVXmlContentDset_id.nextval into :new.id from dual; 
end;
/

create or replace trigger fnaVoucherXmlContent_trigger 
before insert 
on fnaVoucherXmlContent 
for each row 
begin 
	select seq_fnaVoucherXmlContent_id.nextval into :new.id from dual; 
end;
/

create or replace trigger fnaVoucherXml_trigger 
before insert 
on fnaVoucherXml 
for each row 
begin 
	select seq_fnaVoucherXml_id.nextval into :new.id from dual; 
end;
/

create or replace trigger fnaDataSet_trigger 
before insert 
on fnaDataSet 
for each row 
begin 
	select seq_fnaDataSet_id.nextval into :new.id from dual; 
end;
/

create or replace trigger FnaCreateXmlSqlLog_trigger 
before insert 
on FnaCreateXmlSqlLog 
for each row 
begin 
	select seq_FnaCreateXmlSqlLog_id.nextval into :new.id from dual; 
end;
/


alter table fnaFinancesetting add datasourceid VARCHAR2(500)
/
