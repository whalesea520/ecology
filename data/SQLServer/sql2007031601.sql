delete from mainmenuinfo where id=368
go

delete from mainmenuconfig where infoid=368
go


delete from HtmlLabelIndex where id=20253
go

delete from HtmlLabelIndex where id=20254
go

delete from HtmlLabelIndex where id=20255
go
delete from HtmlLabelIndex where id=20256
go

delete from HtmlLabelInfo where indexid=20253
go

delete from HtmlLabelInfo where indexid=20254
go

delete from HtmlLabelInfo where indexid=20255
go
delete from HtmlLabelInfo where indexid=20256
go


INSERT INTO HtmlLabelIndex values(20253,'用于检查文件上传大小的控件没有安装，请检查IE设置，或与管理员联系') 
GO
INSERT INTO HtmlLabelIndex values(20255,'此目录下不能上传超过') 
GO
INSERT INTO HtmlLabelIndex values(20256,'的文件,如果需要传送大文件,请与管理员联系!') 
GO
INSERT INTO HtmlLabelIndex values(20254,'所传附件为:') 
GO
INSERT INTO HtmlLabelInfo VALUES(20253,'用于检查文件上传大小的控件没有安装，请检查IE设置，或与管理员联系',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20253,'don not install activex',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20254,'所传附件为:',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20254,'you upload file is:',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20255,'此目录下不能上传超过',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20255,'this catelog con not uplaod file exceed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20256,'的文件,如果需要传送大文件,请与管理员联系！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20256,'''file,if you want send max file,please contact to administrator!',8) 
GO
