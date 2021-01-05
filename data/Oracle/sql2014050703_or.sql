create or replace trigger MobileSetting_trigger 
before insert on MobileSetting
for each row 
begin
	select MobileSetting_id.nextval into :new.id from dual; 
end;
/

create or replace trigger wfBlacklist_tri 
before insert on workflowBlacklist
for each row 
begin
	select workflowBlacklist_id.nextval into :new.id from dual; 
end;
/