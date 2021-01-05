alter table workflow_currentoperator add nodeid int            
/
alter table workflow_currentoperator add agentorbyagentid int
/
alter table workflow_currentoperator add agenttype char(1)
/
alter table workflow_currentoperator add showorder int
/




alter table workflow_requestViewLog add ordertype char(1)            
/
alter table workflow_requestViewLog add showorder int
/




alter table workflow_requestlog  add showorder int            
/
alter table workflow_requestlog  add agentorbyagentid int
/
alter table workflow_requestlog  add agenttype char(1)
/



alter table HrmRoleMembers add orderby int            
/

