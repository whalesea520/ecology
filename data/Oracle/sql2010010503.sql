alter table workflow_monitor_bound add operator integer null
/
update workflow_monitor_bound set operator=1
/
