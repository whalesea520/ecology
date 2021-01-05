alter table fnaFeeWfInfoLogic add isApplicationBudgetWf int
GO

update fnaFeeWfInfoLogic set isApplicationBudgetWf = 0
GO

update fnaFeeWfInfoLogic set isApplicationBudgetWf = 1 where totalAmtVerification = 0
GO



alter table FnaExpenseInfo add requestidDtlId int
GO

alter table FnaExpenseInfo add sourceDtlNumber int
GO

alter table FnaExpenseInfo add sourceRequestid int
GO

alter table FnaExpenseInfo add sourceRequestidDtlId int
GO

alter table FnaExpenseInfo add budgetperiods int
GO

alter table FnaExpenseInfo add budgetperiodslist int
GO


update FnaExpenseInfo set sourceRequestid = requestid where sourceRequestid is null
GO