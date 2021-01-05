create table FnaBatch4ImpFnaBudget(
  guid1 varchar(50),
  id int, 
  budgetaccount DECIMAL(20,3) 
)
GO

create index idxFnaBatch4ImpFnaBudget1 on FnaBatch4ImpFnaBudget (guid1)
GO 

create index idxFnaBatch4ImpFnaBudget2 on FnaBatch4ImpFnaBudget (id)
GO 

create index idxFnaBatch4ImpFnaBudget3 on FnaBatch4ImpFnaBudget (budgetaccount)
GO 
