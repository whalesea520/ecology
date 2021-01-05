drop trigger "workflow_mould_id_TRIGGER"
/
create or replace trigger workflow_mould_id_TRIGGER
  before insert on workflow_mould
  for each row
begin
  select  workflow_mould_id.nextval into :new.id from dual;
end;
/