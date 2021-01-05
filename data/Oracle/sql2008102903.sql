update workflow_bill set subcompanyid=(select dftsubcomid from SystemSet) where subcompanyid is null
/
alter table workflow_billfield
add tempdsporder decimal(15,2) null
/
update workflow_billfield set tempdsporder=dsporder
/
alter table workflow_billfield 
drop column dsporder 
/
alter table workflow_billfield
add dsporder decimal(15,2) null
/
update workflow_billfield set dsporder=tempdsporder
/
alter table workflow_billfield 
drop column tempdsporder 
/
