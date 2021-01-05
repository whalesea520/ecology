create table BudgetAutoMove(
	id      INTEGER PRIMARY KEY  NOT NULL,  
	orgtype INTEGER,
	orgid   INTEGER,
	budgetperiods INTEGER,
	budgetperiodslist INTEGER,
	operationtime VARCHAR2(19)
)
/
create sequence BudgetAutoMove_Id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger  BudgetAutoMove_Id_Tri
  before insert on BudgetAutoMove
  for each row
begin
  select BudgetAutoMove_Id.nextval into :new.id from dual;
end;
/