delete from HtmlLabelIndex where id=20919 
GO
delete from HtmlLabelInfo where indexid=20919 
GO
delete from HtmlLabelIndex where id=20918 
GO
delete from HtmlLabelInfo where indexid=20918 
GO
delete from HtmlLabelIndex where id=20936 
GO
delete from HtmlLabelInfo where indexid=20936 
GO
delete from HtmlLabelIndex where id=20955 
GO
delete from HtmlLabelInfo where indexid=20955 
GO
delete from HtmlLabelIndex where id=20956 
GO
delete from HtmlLabelInfo where indexid=20956 
GO

INSERT INTO HtmlLabelIndex values(20918,'默认显示维护正文的节点') 
GO
INSERT INTO HtmlLabelInfo VALUES(20918,'默认显示维护正文的节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20918,'The Node Of Default Display Edit Document',8) 
GO
INSERT INTO HtmlLabelIndex values(20919,'是否Word签字') 
GO
INSERT INTO HtmlLabelInfo VALUES(20919,'是否Word签字',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20919,'Is Word Sign',8) 
GO
INSERT INTO HtmlLabelIndex values(20936,'Word签字文档目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(20936,'Word签字文档目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20936,'Word Sign Doc Category',8) 
GO

INSERT INTO HtmlLabelIndex values(20955,'显示/隐藏常用工具') 
GO
INSERT INTO HtmlLabelInfo VALUES(20955,'显示/隐藏常用工具',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20955,'Show/Hide Standard Tools',8) 
GO


INSERT INTO HtmlLabelIndex values(20956,'显示/隐藏格式工具') 
GO
INSERT INTO HtmlLabelInfo VALUES(20956,'显示/隐藏格式工具',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20956,'Show/Hide Formatting Tools',8) 
GO