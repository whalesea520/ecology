update workflow_NodeFormGroup set isadd = '1',isedit = '1',isdelete = '1' where nodeid in(select nodeid from workflow_flownode where workflowid in (select id from workflow_base where formid = 159 and isbill = '1'))
GO