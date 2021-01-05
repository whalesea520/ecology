delete from HtmlLabelIndex where id=22517 
GO
delete from HtmlLabelInfo where indexid=22517 
GO
INSERT INTO HtmlLabelIndex values(22517,'更新分目录和子目录设置') 
GO
delete from HtmlLabelIndex where id=22518 
GO
delete from HtmlLabelInfo where indexid=22518 
GO
INSERT INTO HtmlLabelIndex values(22518,'更新子目录设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(22517,'更新分目录和子目录设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22517,'Refresh the Setting of Subcategory and Seccategory',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22517,'更新分目錄和子目錄設置',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22518,'更新子目录设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22518,'Refresh the Setting of Seccategory',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22518,'更新子目錄設置',9) 
GO


delete from HtmlLabelIndex where id=22580 
GO
delete from HtmlLabelInfo where indexid=22580 
GO
INSERT INTO HtmlLabelIndex values(22580,'以下文档子目录调用了该FTP服务器设置') 
GO
delete from HtmlLabelIndex where id=22578 
GO
delete from HtmlLabelInfo where indexid=22578 
GO
INSERT INTO HtmlLabelIndex values(22578,'以下文档主目录调用了该FTP服务器设置') 
GO
delete from HtmlLabelIndex where id=22579 
GO
delete from HtmlLabelInfo where indexid=22579 
GO
INSERT INTO HtmlLabelIndex values(22579,'以下文档分目录调用了该FTP服务器设置') 
GO
delete from HtmlLabelIndex where id=22581 
GO
delete from HtmlLabelInfo where indexid=22581 
GO
INSERT INTO HtmlLabelIndex values(22581,'以下文件调用了该FTP服务器设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(22578,'以下文档主目录调用了该FTP服务器设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22578,'Those Doc Main Categories call the FTP Server Config',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22578,'以下文檔主目錄調用了該FTP伺服器設置',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22579,'以下文档分目录调用了该FTP服务器设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22579,'Those Doc Sub Categories call the FTP Server Config',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22579,'以下文檔分目錄調用了該FTP伺服器設置',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22580,'以下文档子目录调用了该FTP服务器设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22580,'Those Doc Sec Categories call the FTP Server Config',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22580,'以下文檔子目錄調用了該FTP伺服器設置',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22581,'以下文件调用了该FTP服务器设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22581,'Those Files call the FTP Server Config',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22581,'以下檔調用了該FTP伺服器設置',9) 
GO



delete from SystemRightDetail where rightid=824
GO

delete from SystemRightsLanguage where id=824
GO

delete from SystemRights where id=824
GO

insert into SystemRights (id,rightdesc,righttype) values (824,'FTP服务器设置','1') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (824,8,'FTP Server Config','FTP Server Config') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (824,9,'FTP伺服器設置','FTP伺服器設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (824,7,'FTP服务器设置','FTP服务器设置') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4335,'FTP服务器设置添加','DocFTPConfigAdd:Add',824) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4336,'FTP服务器设置编辑','DocFTPConfigEdit:Edit',824) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4337,'FTP服务器设置删除','DocFTPConfigEdit:Delete',824) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4338,'FTP服务器设置日志查看','DocFTPConfig:Log',824) 
GO