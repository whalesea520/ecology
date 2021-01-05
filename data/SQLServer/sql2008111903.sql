insert into workflow_billfield(billId,fieldName,fieldLabel,fieldDbType,fieldHtmlType,type,viewType,fromUser,dspOrder)
select a.id,'manager',144,'int','3',1,'0','1',max(b.dspOrder)+1
from workflow_bill a, workflow_billfield b
where a.id=b.billId
  and a.id in(10,11,13,14,15,18,19,40,41,42,47,156,157,158,163,201) 
  and not exists(select 1 from workflow_billfield where fieldName='manager' and workflow_billfield.billId=a.id)
group by a.id
GO

alter table  bill_CptFetchMain add manager int null
GO
alter table  Bill_FnaLoanApply add manager int null
GO
alter table  Bill_FnaPayApply add manager int null
GO
alter table  Bill_FnaWipeApply add manager int null
GO
alter table  CarUseApprove add manager int null
GO
alter table  Bill_HrmRedeploy add manager int null
GO
alter table  Bill_HrmDismiss add manager int null
GO
alter table  Bill_HrmHire add manager int null
GO
alter table  Bill_HrmUseDemand add manager int null
GO
alter table  bill_Discard add manager int null
GO
