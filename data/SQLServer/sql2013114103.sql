alter table workflow_nodelink add CustomWorkflowid integer 
go
alter table workflow_nodelink add flowobjectreject VARCHAR(100)
go
alter table workflow_nodelink add flowobjectsubmit VARCHAR(100)
go
alter table workflow_nodelink add isremind_csh char(1)
go
alter table workflow_nodelink add remindhour_csh int
go
alter table workflow_nodelink add remindminute_csh int
go
alter table workflow_nodelink add FlowRemind_csh char(1)
go
alter table workflow_nodelink add MsgRemind_csh char(1)
go
alter table workflow_nodelink add MailRemind_csh char(1)
go
alter table workflow_nodelink add isnodeoperator_csh char(1)
go
alter table workflow_nodelink add iscreater_csh char(1)
go
alter table workflow_nodelink add ismanager_csh char(1)
go
alter table workflow_nodelink add isother_csh char(1)
go
alter table workflow_nodelink add remindobjectids_csh text
go
alter table workflow_currentoperator add isreminded_csh char(1)
go
alter table workflow_currentoperator add wfreminduser_csh text
go
alter table workflow_currentoperator add wfusertypes_csh text
go
alter table workflow_nodelink add selectnodepass integer 
go
alter table workflow_nodelink add CustomWorkflowid_csh integer
go
alter table workflow_nodelink add InfoCentreRemind char(1)
go
alter table workflow_nodelink add InfoCentreRemind_csh char(1)
go