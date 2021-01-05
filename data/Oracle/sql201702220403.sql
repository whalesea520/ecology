create table hrm_sync_log(
id number PRIMARY KEY NOT NULL,
DataId       varchar(10),
Outkey       varchar(100),
DataType     int  ,
CreateDate  varchar(10),
CreateTime   varchar(8),
  delType int
)
/
create sequence hrm_sync_log_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger hrm_sync_log_Tri
before insert on hrm_sync_log
for each row
begin
select hrm_sync_log_id.nextval into :new.id from dual;
end;
/