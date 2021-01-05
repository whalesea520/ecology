alter table workflow_flownode add isfeedback char(1)
GO
update workflow_flownode set isfeedback='1'
GO
