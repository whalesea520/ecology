delete from HtmlLabelIndex where id in (20179,20180,20181)
go
delete from HtmlLabelInfo where indexid in (20179,20180,20181)
go

INSERT INTO HtmlLabelIndex values(20179,'图片上传插件') 
GO
INSERT INTO HtmlLabelIndex values(20180,'用于实现批量上传图片的功能') 
GO
INSERT INTO HtmlLabelIndex values(20181,'根据您使用的操作系统版本下载相应的文件，解压缩后点击setup.exe安装。') 
GO
INSERT INTO HtmlLabelInfo VALUES(20179,'图片上传插件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20179,'Image Uploader',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20180,'用于实现批量上传图片的功能',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20180,'support batch image uploader, support image thumbnail view and image preview functiond',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20181,'根据您使用的操作系统版本下载相应的文件，解压缩后点击setup.exe安装。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20181,'Extract the zip file.',8) 
GO