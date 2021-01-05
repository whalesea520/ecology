delete from HtmlLabelIndex where id=21254 
GO
delete from HtmlLabelInfo where indexid=21254 
GO
INSERT INTO HtmlLabelIndex values(21254,'主流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(21254,'主流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21254,'Main Workflow',8) 
GO

delete from HtmlLabelIndex where id=21255 
GO
delete from HtmlLabelInfo where indexid=21255 
GO
INSERT INTO HtmlLabelIndex values(21255,'平行流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(21255,'平行流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21255,'Parallel Workflow',8) 
GO