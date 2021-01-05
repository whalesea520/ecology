delete from HtmlLabelIndex where id in(20229,20598)
GO
delete from HtmlLabelInfo where indexId in(20229,20598)
GO
INSERT INTO HtmlLabelIndex values(20229,'套红节点') 
GO
INSERT INTO HtmlLabelInfo VALUES(20229,'套红节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20229,'Use Templet Node',8) 
GO
INSERT INTO HtmlLabelIndex values(20598,'流程基本属性') 
GO
INSERT INTO HtmlLabelInfo VALUES(20598,'流程基本属性',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20598,'Workflow Basic Attribute',8) 
GO
