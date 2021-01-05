alter table fnaFeeWfInfoLogic add isApplicationBudgetWf INTEGER
/

update fnaFeeWfInfoLogic set isApplicationBudgetWf = 0
/

update fnaFeeWfInfoLogic set isApplicationBudgetWf = 1 where totalAmtVerification = 0
/



alter table FnaExpenseInfo add requestidDtlId INTEGER
/

alter table FnaExpenseInfo add sourceDtlNumber int
/

alter table FnaExpenseInfo add sourceRequestid INTEGER
/

alter table FnaExpenseInfo add sourceRequestidDtlId INTEGER
/

alter table FnaExpenseInfo add budgetperiods int
/

alter table FnaExpenseInfo add budgetperiodslist INTEGER
/

update FnaExpenseInfo set sourceRequestid = requestid where sourceRequestid is null

/