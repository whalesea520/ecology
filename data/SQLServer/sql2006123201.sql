delete from HtmlLabelIndex where id=20073
GO
delete from HtmlLabelInfo where indexid=20073
GO

INSERT INTO HtmlLabelIndex values(20073,'该文档标题在当前目录已经存在，请重新输入！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20073,'该文档标题在当前目录已经存在，请重新输入！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20073,'The subject has existed,Please input another!',8) 
GO
