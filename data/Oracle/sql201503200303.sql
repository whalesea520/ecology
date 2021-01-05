update workflow_bill set viewpage='' where id=18
/
update workflow_billfield set detailtable='bill_CptAdjustDetail' where billid=18 and viewtype='1'
/
insert into Workflow_billdetailtable(billid,tablename) values(18,'bill_CptAdjustDetail')
/