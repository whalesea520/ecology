
INSERT INTO HtmlLabelIndex values(19677,'显示流程状态') 
GO
INSERT INTO HtmlLabelIndex values(19678,'隐藏流程状态') 
GO
INSERT INTO HtmlLabelIndex values(19676,'隐藏流程图') 
GO
INSERT INTO HtmlLabelIndex values(19675,'显示流程图') 
GO
INSERT INTO HtmlLabelInfo VALUES(19675,'显示流程图',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19675,'Show Workflow Chart',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19676,'隐藏流程图',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19676,'Hide Workflow Chart',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19677,'显示流程状态',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19677,'Show Workflow Status',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19678,'隐藏流程状态',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19678,'Hide Workflow Status',8) 
GO

update HtmlLabelInfo set  labelName='Workflow Status' where indexid=19061 and languageid=8
GO