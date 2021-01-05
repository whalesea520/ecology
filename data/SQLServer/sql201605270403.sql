alter table FnaBudgetfeeType add displayOrder DECIMAL(6,3)
GO
update FnaBudgetfeeType set displayOrder=0
GO