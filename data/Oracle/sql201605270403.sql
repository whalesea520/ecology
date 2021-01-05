alter table FnaBudgetfeeType add displayOrder DECIMAL(6,3)
/
update FnaBudgetfeeType set displayOrder=0
/