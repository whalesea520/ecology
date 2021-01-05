update workflow_bill set viewpage='' where id=18
go
update workflow_billfield set detailtable='bill_CptAdjustDetail' where billid=18 and viewtype='1'
go
insert into Workflow_billdetailtable(billid,tablename) values(18,'bill_CptAdjustDetail')
go