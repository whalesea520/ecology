update workflow_createdoc set wfstatus=1 where status=1 and workflowId in(select id from workflow_base where isWorkflowDoc=1 )
/