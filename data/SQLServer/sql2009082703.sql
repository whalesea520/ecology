alter table workflow_flownode add toexcel char(1)
GO
update workflow_flownode set toexcel='1'
GO
