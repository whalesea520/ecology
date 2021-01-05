create or replace trigger FnaFeetypeWfbrowdef1_trigger 
before insert 
on FnaFeetypeWfbrowdef  
for each row 
begin 
	select FnaFeetypeWfbrowdef_ID.nextval into :new.id from dual; 
end;
/

create or replace trigger FnaFeetypeWfbrowdef2_trigger 
before insert 
on FnaFeetypeWfbrowdef_dt1  
for each row 
begin 
	select FnaFeeWfbrowdefDt_ID.nextval into :new.id from dual; 
end;
/