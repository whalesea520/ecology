INSERT INTO HtmlLabelIndex values(17606,'是否默认说明') 
GO
INSERT INTO HtmlLabelInfo VALUES(17606,'是否默认说明',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17606,'is Default Name',8) 
GO

/*修改workflow_base表结构，记录是否生成默认说明*/
ALTER TABLE workflow_base
ADD defaultName int NULL
GO

UPDATE workflow_base
SET defaultName=1
GO