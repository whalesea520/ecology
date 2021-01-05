alter table FnaBudgetfeeType add budgetAutoMove integer
/

update FnaBudgetfeeType set budgetAutoMove = 1
/

alter table FnaSystemSet add budgetAutoMovePending integer
/

update FnaSystemSet set budgetAutoMovePending = 1
/