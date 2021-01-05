
drop trigger FnaRuleSetDtlFcc_trigger
/
create or replace trigger FnaRuleSetDtlFcc_trigger 
before insert 
on FnaRuleSetDtlFcc 
for each row 
begin 
	select seq_FnaRuleSetDtlFcc_id.nextval into :new.id from dual; 
end;
/