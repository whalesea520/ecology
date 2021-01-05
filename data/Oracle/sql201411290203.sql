CREATE OR replace trigger DocDetailLog_Trigger
	before INSERT ON DocDetailLog
	for each row
	begin
		SELECT DocDetailLog_id.nextval INTO:new.id from dual;
	end;
/

CREATE OR REPLACE  TRIGGER docdetaillogins_trigger 
  after insert on docdetaillog
  for each row 
  begin
	SysMaintenanceLog_proc(:new.docid,
	:new.docsubject,
	:new.operateuserid ,
	:new.usertype,
	:new.operatetype,
	'',
	'301',
	:new.operatedate,
	:new.operatetime,
	1,
	:new.clientaddress,
	0 );
end;
/