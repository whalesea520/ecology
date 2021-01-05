insert into SystemRights (id,rightdesc,righttype) values (448,'文档下载日志','1') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (448,7,'文档下载日志','文档下载日志') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (448,8,'Doc download log','Doc download log') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3139,'文档下载日志查看','DocDownloadLog:View',448) 
GO

insert into SystemRightToGroup (groupid, rightid) values (5,448)
GO
insert into SystemRightToGroup (groupid, rightid) values (2,448)
GO
insert into systemrightroles(rightid,roleid,rolelevel) values (448,3,2)
GO