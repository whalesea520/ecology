create table ScheduleApplicationRule(
id INTEGER not null,
sharetype INTEGER ,
seclevel VARCHAR2(50),
seclevelend VARCHAR2(50),
reportname VARCHAR2(100))
/
create sequence ScheduleApplicationRule_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20
/
create or replace trigger sApplicationRule_TRIGGER
  before insert on ScheduleApplicationRule
  for each row
begin
  select ScheduleApplicationRule_ID.nextval into :new.id from dual;
end;
/