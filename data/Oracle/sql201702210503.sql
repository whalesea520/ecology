ALTER TABLE datashowset ADD CreateDate varchar2(10)
/
ALTER TABLE datashowset ADD CreateTime varchar2(8)
/
ALTER TABLE datashowset ADD ModifyDate varchar2(10)
/
ALTER TABLE datashowset ADD ModifyTime varchar2(8)
/
UPDATE datashowset SET CreateDate=to_char(sysdate,'yyyy-MM-dd'),CreateTime=to_char(sysdate,'HH24:mm:ss'),ModifyDate=to_char(sysdate,'yyyy-MM-dd'),ModifyTime=to_char(sysdate,'HH24:mm:ss')
/
Create TABLE datashowexecutelog (
id number PRIMARY KEY NOT NULL,
datashowName  varchar2(200),
datashowCount number,
CreateDate varchar2(10),
CreateTime varchar2(8),
ModifyDate varchar2(10),
ModifyTime varchar2(8)
)
/
create sequence datashowexecutelog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger datashowexecutelog_Tri
before insert on datashowexecutelog
for each row
begin
select datashowexecutelog_id.nextval into :new.id from dual;
end;
/