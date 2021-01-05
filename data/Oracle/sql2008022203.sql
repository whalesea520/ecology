alter table Workflow_SubwfSet add isread int default 0
/
update Workflow_SubwfSet set isread = 0
/
