delete from SystemRightDetail where rightid =1167
GO
delete from SystemRightsLanguage where id =1167
GO
delete from SystemRights where id =1167
GO
insert into SystemRights (id,rightdesc,righttype) values (1167,'文档附件批量下载权限','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1167,7,'文档附件批量下载权限','文档附件批量下载权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1167,9,'文檔附件批量下載權限','文檔附件批量下載權限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1167,8,'doc file batch download','doc file batch download') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42383,'文档附件批量下载权限','DocFileBatchDownLoad:ALL',1167) 
GO