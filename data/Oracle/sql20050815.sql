/* 数据导入入口表 */
CREATE TABLE Workflow_DataInput_entry(
    id  integer NOT NULL ,
    WorkFlowID    integer,
    TriggerFieldName   varchar2(50)
)
/
create sequence Workflow_DataInput_entry_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DataInput_entry_Trigger
before insert on Workflow_DataInput_entry
for each row
begin
select Workflow_DataInput_entry_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Workflow_DataInput_main(
    id  integer NOT NULL ,
    entryID    integer,
    WhereClause varchar2(1000),
    IsCycle   integer  default 1,
    OrderID	integer  default 0
)
/
create sequence Workflow_DataInput_main_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DataInput_main_Trigger
before insert on Workflow_DataInput_main
for each row
begin
select Workflow_DataInput_main_id.nextval into :new.id from dual;
end;
/

/* 数据导入关联表 */
CREATE TABLE Workflow_DataInput_table(
    id  integer NOT NULL ,
    DataInputID    integer,
    TableName varchar2(40),
    Alias   varchar2(10)
)
/
create sequence Workflow_DataInput_table_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DataInput_table_Trigger
before insert on Workflow_DataInput_table
for each row
begin
select Workflow_DataInput_table_id.nextval into :new.id from dual;
end;
/

/* 数据导入输入输出表 */
CREATE TABLE Workflow_DataInput_field(
    id  integer NOT NULL ,
    DataInputID    integer,
    TableID	integer,
    Type	integer,
    DBFieldName   varchar2(40),
    PageFieldName	varchar2(40)
)
/
create sequence Workflow_DataInput_field_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DataInput_field_Trigger
before insert on Workflow_DataInput_field
for each row
begin
select Workflow_DataInput_field_id.nextval into :new.id from dual;
end;
/

/* 数据导入条件表*/
CREATE TABLE Workflow_DataInput_condition(
    id  integer NOT NULL,
    DataInputID    integer,
    FieldName	varchar2(40),
    Connection	integer,
    Value   varchar2(200)
)
/
create sequence Wf_DataInput_condition_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DataIn_condition_Tri
before insert on Workflow_DataInput_condition
for each row
begin
select Wf_DataInput_condition_id.nextval into :new.id from dual;
end;
/

/*单据主从关系表*/
CREATE TABLE Workflow_billdetailtable(
    id  integer NOT NULL,
    billid    integer,
    tablename   varchar2(50),
    title	varchar2(200),
    orderid   integer default 0
)
/
create sequence Workflow_billdetailtable_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Wf_billdetailtable_Tri
before insert on Workflow_billdetailtable
for each row
begin
select Workflow_billdetailtable_id.nextval into :new.id from dual;
end;
/


/*增加一列存放明细表表名*/
alter table workflow_billfield add  detailtable varchar2(50) 
/