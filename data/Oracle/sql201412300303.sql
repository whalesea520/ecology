alter table workflow_browsertype add orderid int
/
update workflow_browsertype set orderid = id
/