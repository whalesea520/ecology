
delete from HtmlLabelIndex where id=19986
GO
INSERT INTO HtmlLabelIndex values(19986,'有新版本的文档可查看，是否查看最新版本？') 
GO

delete from HtmlLabelInfo where indexid=19986
GO
INSERT INTO HtmlLabelInfo VALUES(19986,'有新版本的文档可查看，是否查看最新版本 ？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19986,'There is the newest version can view,view the newest version now ?',8) 
GO