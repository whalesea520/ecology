create table outerdatawflog(
id int,
Outerdatawfid int,
Outkey varchar2(100),
Workflowid int,
RequestId int,
Triggerflag int,
CreateDate varchar2(10),
CreateTime varchar2(8)
)
/

CREATE SEQUENCE outerdatawflog_sequence
INCREMENT BY 1 
START WITH 1 
NOMAXVALUE 
NOCYCLE 
NOCACHE 
/


CREATE TRIGGER outerdatawflog_triger BEFORE
INSERT ON outerdatawflog FOR EACH ROW WHEN (new.id is null)
begin
select outerdatawflog_sequence.nextval into:new.id from dual;
end;
/

alter table outerdatawfset add CreateDate varchar2(10)
/
alter table outerdatawfset add CreateTime varchar2(10)
/
alter table outerdatawfset add ModifyDate varchar2(10)
/
alter table outerdatawfset add ModifyTime varchar2(10)
/