alter table workflow_currentoperator add nodeid int            
GO
alter table workflow_currentoperator add agentorbyagentid int
GO
alter table workflow_currentoperator add agenttype char(1)
GO
alter table workflow_currentoperator add showorder int
GO




alter table workflow_requestViewLog add ordertype char(1)            
GO
alter table workflow_requestViewLog add showorder int
GO




alter table workflow_requestlog  add showorder int            
GO
alter table workflow_requestlog  add agentorbyagentid int
GO
alter table workflow_requestlog  add agenttype char(1)
GO



alter table HrmRoleMembers add orderby int            
GO




