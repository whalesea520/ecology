alter table FnaBudgetfeeType add budgetAutoMove int
GO

update FnaBudgetfeeType set budgetAutoMove = 1
GO

alter table FnaSystemSet add budgetAutoMovePending int
GO

update FnaSystemSet set budgetAutoMovePending = 1
GO