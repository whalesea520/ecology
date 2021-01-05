create or replace trigger WorkPlanViewLog_Trigger before insert on WorkPlanViewLog for each row
begin
  select WorkPlanViewLog_id.nextval into :new.id from dual;
end;
/
create or replace trigger workplanviewlog_after_trigger
  after insert on WorkPlanViewLog
  for each row
  
DECLARE 
relatedname varchar(400);
  begin
select  name into relatedname from workplan where id=:new.workPlanId;
 
 SysMaintenanceLog_proc(
:new.workPlanId,
 relatedname,
:new.userId,
:new.usertype,
:new.viewType,
'日程前台操作',
'91',
:new.logDate,
:new.logTime,
1,
:new.ipAddress,
0 );
end;
/
