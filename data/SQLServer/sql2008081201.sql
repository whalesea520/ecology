delete from HtmlLabelIndex where id=21700 
GO
delete from HtmlLabelInfo where indexid=21700 
GO
INSERT INTO HtmlLabelIndex values(21700,'您打开的文档目前为查看状态') 
GO
delete from HtmlLabelIndex where id=21701 
GO
delete from HtmlLabelInfo where indexid=21701 
GO
INSERT INTO HtmlLabelIndex values(21701,'无法保存您的编辑') 
GO
INSERT INTO HtmlLabelInfo VALUES(21700,'您打开的文档目前为查看状态',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21700,'The document you open is view status',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21701,'无法保存您的编辑',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21701,'it is unable to save your edits',8) 
GO
