create or replace trigger MeetingLog_trigger
  after insert on MeetingLog
  for each row 
begin 
 
 SysMaintenanceLog_proc(
:new.relatedid,
:new.relatedname,
:new.operateuserid,
:new.operateusertype,
:new.operatetype,
:new.operatedesc,
:new.operateitem,
:new.operatedate,
:new.operatetime,
:new.operatesmalltype,
:new.clientaddress,
0 );
end;
/