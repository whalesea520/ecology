delete HtmlLabelIndex where id=20823
GO
delete HtmlLabelInfo where indexid=20823
GO
delete HtmlLabelIndex where id=20824
GO
delete HtmlLabelInfo where indexid=20824
GO
INSERT INTO HtmlLabelIndex values(20824,'其他设置') 
GO
INSERT INTO HtmlLabelIndex values(20823,'模板管理') 
GO
INSERT INTO HtmlLabelInfo VALUES(20823,'模板管理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20823,'Templet Manager',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20824,'其他设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20824,'other setting',8) 
GO

delete HtmlLabelIndex where id=16448
GO
delete HtmlLabelInfo where indexid=16448
GO
delete HtmlLabelIndex where id=19456
GO
delete HtmlLabelInfo where indexid=19456
GO
INSERT INTO HtmlLabelIndex values(16448,'模板设置') 
GO
INSERT INTO HtmlLabelIndex values(19456,'目录模板') 
GO
INSERT INTO HtmlLabelInfo VALUES(16448,'模板设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16448,'MouldSet',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19456,'目录模板',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19456,'DirectoryMould',8) 
GO
