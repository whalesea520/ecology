insert into workflow_versioninfo (wfid, wfversionid) 
select a.workflowid wf1, a.workflowid wf2   
from fnaFeeWfInfo a 
where not EXISTS (
	select 1 from workflow_versioninfo wv 
	where wv.wfid = a.workflowid or wv.wfversionid = a.workflowid 
) 
/