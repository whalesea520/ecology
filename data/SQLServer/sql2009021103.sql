alter table workflow_nodelink add ProcessorOpinion varchar(200)
GO
alter table workflow_nodelink add wfrequestid int
GO
alter table workflow_nodecustomrcmenu add newOverTimeName7 varchar(50)
GO
alter table workflow_nodecustomrcmenu add newOverTimeName8 varchar(50)
GO
alter table workflow_nodecustomrcmenu add hasovertime char(1)
GO
alter table workflow_monitor_bound add isdelete char(1)
GO
alter table workflow_monitor_bound add isForceDrawBack char(1)
GO
alter table workflow_monitor_bound add isForceOver char(1)
GO
update workflow_monitor_bound set isdelete='1',isForceDrawBack='1',isForceOver='1'
GO