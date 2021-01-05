delete from SystemRightDetail where rightid =1167
/
delete from SystemRightsLanguage where id =1167
/
delete from SystemRights where id =1167
/
insert into SystemRights (id,rightdesc,righttype) values (1167,'文档附件批量下载权限','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1167,7,'文档附件批量下载权限','文档附件批量下载权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1167,9,'文檔附件批量下載權限','文檔附件批量下載權限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1167,8,'doc file batch download','doc file batch download') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42383,'文档附件批量下载权限','DocFileBatchDownLoad:ALL',1167) 
/