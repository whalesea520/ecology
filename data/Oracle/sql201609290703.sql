alter table hrm_att_proc_set add ishalfday NUMBER 
/
alter table hrmLeaveTypeColor add isCalWorkDay NUMBER  default 1
/
alter table hrmLeaveTypeColor add relateweekday NUMBER 
/
create table hrmscheduleapplication
(
  id           INTEGER not null,
  unit integer,
  type integer
)
/
create sequence hrmscheduleapplication_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 50
order
/

create or replace trigger hrmscheduleapplication_TRIGGER
  before insert on hrmscheduleapplication
  for each row
begin
  select hrmscheduleapplication_ID.nextval into :new.id from dual;
end;
/