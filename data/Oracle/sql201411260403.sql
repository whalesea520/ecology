DROP SEQUENCE workflow_codeRegulate_seq
/
CREATE SEQUENCE workflow_codeRegulate_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger workflow_codeRegulate_Tri
  before insert on workflow_codeRegulate
  for each row
begin
  select workflow_codeRegulate_seq.nextval into :new.id from dual;
end;
/