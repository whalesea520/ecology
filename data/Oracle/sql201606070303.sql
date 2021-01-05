create or replace trigger FnaBudgetInfoOperFlag_Trigger before insert on FnaBudgetInfoOperFlag for each row 
begin select seq_FnaBudgetInfoOperFlag_ID.nextval INTO :new.id from dual; end;
/