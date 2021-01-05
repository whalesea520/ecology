update workflow_bill set subcompanyid=(select dftsubcomid from SystemSet) where subcompanyid is null
GO
alter table workflow_billfield
add tempdsporder decimal(15,2) null
GO
update workflow_billfield set tempdsporder=dsporder
GO
alter table workflow_billfield 
drop column dsporder 
GO
alter table workflow_billfield
add dsporder decimal(15,2) null
GO
update workflow_billfield set dsporder=tempdsporder
GO
alter table workflow_billfield 
drop column tempdsporder 
GO
