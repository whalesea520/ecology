create or replace trigger CommunicateLog_trigger
  after insert on CommunicateLog
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