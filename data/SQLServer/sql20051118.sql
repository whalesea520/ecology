CREATE 
  INDEX Wfl_DocShareInfo_idx ON Workflow_DocShareInfo (docId  desc , userId  desc , requestId  desc )
GO

CREATE 
  INDEX Workflow_Agent_idx ON Workflow_Agent (workflowId  desc , beagenterId  desc)
GO
