ALTER TABLE rule_expressionbase ALTER COLUMN redius int
GO
ALTER TABLE rule_expressionbase ALTER COLUMN meetcondition int
GO
ALTER TABLE rule_expressionbase ALTER COLUMN jingdu VARCHAR(100)
GO
ALTER TABLE rule_expressionbase ALTER COLUMN weidu VARCHAR(100)
GO
ALTER TABLE rule_expressionbase ALTER COLUMN nodeid int
GO
ALTER TABLE rule_mapitem ADD nodeid INT
GO
ALTER TABLE rule_mapitem ADD meetcondition INT
GO