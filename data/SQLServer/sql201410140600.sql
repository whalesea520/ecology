delete from SystemRightDetail where rightid =1747
GO
delete from SystemRightsLanguage where id =1747
GO
delete from SystemRights where id =1747
GO
insert into SystemRights (id,rightdesc,righttype) values (1747,'权限删除维护','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1747,9,'權限刪除維護','權限刪除維護') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1747,7,'权限删除维护','权限删除维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1747,8,'HrmRrightDelete','HrmRrightDelete') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42978,'权限删除','HrmRrightDelete:delete',1747) 
GO
