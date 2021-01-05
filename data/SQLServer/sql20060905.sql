INSERT INTO HtmlLabelIndex values(19649,'是否需要确认') 
GO
INSERT INTO HtmlLabelInfo VALUES(19649,'是否需要确认',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19649,'Need Affirmance',8) 
GO

alter table workflow_base add needAffirmance char(1)
GO