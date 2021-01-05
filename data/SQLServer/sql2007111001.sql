delete from HtmlLabelIndex where id=21015 
GO
delete from HtmlLabelInfo where indexid=21015 
GO
INSERT INTO HtmlLabelIndex values(21015,'文件名称格式错误，请检查文件名称是否正确！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21015,'文件名称格式错误，请检查文件名称是否正确！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21015,'File Name Error',8) 
GO

delete from HtmlLabelIndex where id=21090 
GO
delete from HtmlLabelInfo where indexid=21090 
GO
INSERT INTO HtmlLabelIndex values(21090,'用于检查文件上传大小的控件没有安装，请检查IE设置，或与管理员联系！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21090,'用于检查文件上传大小的控件没有安装，请检查IE设置，或与管理员联系！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21090,'File checking control is not install,please check ie setting or contact with sysadmin',8) 
GO
