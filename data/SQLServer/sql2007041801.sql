delete from HtmlLabelIndex where id=20300
GO
delete from HtmlLabelInfo where indexId=20300
GO
INSERT INTO HtmlLabelIndex values(20300,'当前版本的文档无权查看。') 
GO
INSERT INTO HtmlLabelInfo VALUES(20300,'当前版本的文档无权查看。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20300,'The version couldn''t been view.',8) 
GO
