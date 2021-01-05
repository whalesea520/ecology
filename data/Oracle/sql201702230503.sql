Create TABLE ActionExecuteLog (
id number PRIMARY KEY NOT NULL,
actionid varchar2(4000) ,
actiontype number,
datashowCount number,
CreateDate varchar2(10),
CreateTime varchar2(8)
)
/
create sequence ActionExecuteLog_seq
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger ActionExecuteLog_Tri
before insert on ActionExecuteLog
for each row
begin
select ActionExecuteLog_seq.nextval into :new.id from dual;
end;
/
ALTER TABLE actionsetting ADD CreateDate varchar2(10)
/
ALTER TABLE actionsetting ADD CreateTime varchar2(8)
/
ALTER TABLE actionsetting ADD ModifyDate varchar2(10)
/
ALTER TABLE actionsetting ADD ModifyTime varchar2(8)
/
update actionsetting set CreateDate=to_char(sysdate,'yyyy-mm-dd'),ModifyDate=to_char(sysdate,'yyyy-mm-dd'),CreateTime=to_char(sysdate,'hh24:mi:ss'),ModifyTime=to_char(sysdate,'hh24:mi:ss')
/
ALTER TABLE formactionset ADD CreateDate varchar2(10)
/
ALTER TABLE formactionset ADD CreateTime varchar2(8)
/
ALTER TABLE formactionset ADD ModifyDate varchar2(10)
/
ALTER TABLE formactionset ADD ModifyTime varchar2(8)
/
update formactionset  set CreateDate=to_char(sysdate,'yyyy-mm-dd'),ModifyDate=to_char(sysdate,'yyyy-mm-dd'),CreateTime=to_char(sysdate,'hh24:mi:ss'),ModifyTime=to_char(sysdate,'hh24:mi:ss')
/
ALTER TABLE wsformactionset ADD CreateDate varchar2(10)
/
ALTER TABLE wsformactionset ADD CreateTime varchar2(8)
/
ALTER TABLE wsformactionset ADD ModifyDate varchar2(10)
/
ALTER TABLE wsformactionset ADD ModifyTime varchar2(8)
/
update wsformactionset set CreateDate=to_char(sysdate,'yyyy-mm-dd'),ModifyDate=to_char(sysdate,'yyyy-mm-dd'),CreateTime=to_char(sysdate,'hh24:mi:ss'),ModifyTime=to_char(sysdate,'hh24:mi:ss')
/