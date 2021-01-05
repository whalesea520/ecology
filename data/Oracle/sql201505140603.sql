alter table workflow_monitor_detail drop column isedit
/
create index infoid on workflow_monitor_detail (infoid)
/