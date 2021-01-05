update FnaExpenseInfo set requestid = 0 where requestid is null
GO
update FnaExpenseInfo set requestidDtlId = 0 where requestidDtlId is null
GO
update FnaExpenseInfo set sourceRequestid = 0 where sourceRequestid is null
GO
update FnaExpenseInfo set sourceRequestidDtlId = 0 where sourceRequestidDtlId is null
GO
update FnaExpenseInfo set sourceDtlNumber = 0 where sourceDtlNumber is null
GO