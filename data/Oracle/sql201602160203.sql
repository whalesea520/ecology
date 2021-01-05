create table mode_remindNowLog(
   id int  primary key,
   remindjobid int,
   modeid int,
   formid int,
   billid int
)
/
create sequence mode_remindNowLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_remindNowLog_id_Tri
before insert on mode_remindNowLog
for each row
begin
select mode_remindNowLog_id.nextval into :new.id from dual;
end;
/