ALTER TABLE workflow_formdict ADD locatetype char(1)
GO
ALTER TABLE workflow_billfield  ADD locatetype char(1)
GO
ALTER TABLE rule_expressionbase ADD redius VARCHAR(1000),meetcondition VARCHAR(1000),nodeid VARCHAR(1000),jingdu VARCHAR(1000),weidu VARCHAR(1000)
GO