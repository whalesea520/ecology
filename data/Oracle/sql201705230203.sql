create table FnaBatch4ImpFnaBudget(
  guid1 varchar2(50),
  id integer, 
  budgetaccount DECIMAL(20,3) 
)
/

create index idxFnaBatch4ImpFnaBudget1 on FnaBatch4ImpFnaBudget (guid1)
/

create index idxFnaBatch4ImpFnaBudget2 on FnaBatch4ImpFnaBudget (id)
/

create index idxFnaBatch4ImpFnaBudget3 on FnaBatch4ImpFnaBudget (budgetaccount)
/
