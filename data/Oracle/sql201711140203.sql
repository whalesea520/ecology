create or replace trigger budgetAutoMove_trigger 
before insert 
on BudgetAutoMove 
for each row 
begin 
	select BudgetAutoMove_Id.nextval into :new.id from dual; 
end;
/