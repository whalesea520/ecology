drop trigger Prj_task_needwf_Trigger
/

CREATE OR REPLACE TRIGGER Prj_task_needwf_Trigger before insert on Prj_task_needwf for each row 
begin select Prj_task_needwf_id.nextval into :new.id from dual; end;
/
