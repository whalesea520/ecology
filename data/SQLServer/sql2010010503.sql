alter table workflow_monitor_bound add operator int null
GO
update workflow_monitor_bound set operator=1
GO
