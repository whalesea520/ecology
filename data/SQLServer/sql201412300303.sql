alter table workflow_browsertype add orderid int
GO
update workflow_browsertype set orderid = id
GO