INSERT INTO workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) select nodeid,12,1,0,0 from workflow_flownode where workflowid = 1
GO