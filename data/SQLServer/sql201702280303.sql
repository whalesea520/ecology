delete WORKFLOW_BILLDETAILTABLE where billid=18
go
insert into WORKFLOW_BILLDETAILTABLE(billid,tablename) values(18,'bill_CptAdjustDetail')
go
delete WORKFLOW_BILLDETAILTABLE where billid=19
go
insert into WORKFLOW_BILLDETAILTABLE(billid,tablename) values(19,'bill_CptFetchDetail')
go
delete WORKFLOW_BILLDETAILTABLE where billid=201
go
insert into WORKFLOW_BILLDETAILTABLE(billid,tablename) values(201,'bill_Discard_Detail')
go