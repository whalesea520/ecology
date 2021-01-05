update workflow_billfield set detailtable = 'bill_CptApplyMain'  where billid = 14 and viewtype = 1
GO
update workflow_billfield set detailtable = 'bill_CptRequireMain' where billid = 15 and viewtype = 1
GO
update workflow_billfield set detailtable = 'bill_CptFetchDetail' where billid = 19 and viewtype = 1
GO