delete from WORKFLOW_BILLDETAILTABLE where billid in(7,156,157,158,159)
/
insert into WORKFLOW_BILLDETAILTABLE(billid,tablename,orderid) values(7,'Bill_ExpenseDetail',1)
/
insert into WORKFLOW_BILLDETAILTABLE(billid,tablename,orderid) values(156,'Bill_FnaPayApplyDetail',1)
/
insert into WORKFLOW_BILLDETAILTABLE(billid,tablename,orderid) values(157,'Bill_FnaLoanApplyDetail',1)
/
insert into WORKFLOW_BILLDETAILTABLE(billid,tablename,orderid) values(158,'Bill_FnaWipeApplyDetail',1)
/
insert into WORKFLOW_BILLDETAILTABLE(billid,tablename,orderid) values(159,'Bill_FnaBudgetChgApplyDetail',1)
/
