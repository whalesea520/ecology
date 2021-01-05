create table workflow_logviewusers(
	logid int,
	userid int
)
GO

alter table workflow_flownode add notseeeachother char(1)
GO