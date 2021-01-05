ALTER TABLE workflow_flownode ADD UseExceptionHandle CHAR(1)
GO
ALTER TABLE workflow_flownode ADD ExceptionHandleWay CHAR(1)
GO
ALTER TABLE workflow_flownode ADD FlowToAssignNode INT
GO