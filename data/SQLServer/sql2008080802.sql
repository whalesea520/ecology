delete from FnaExpenseInfo where requestid not in (select requestid from workflow_requestbase)
go