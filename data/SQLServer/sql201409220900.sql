delete from SystemRightDetail where rightid =1736
GO
delete from SystemRightsLanguage where id =1736
GO
delete from SystemRights where id =1736
GO
insert into SystemRights (id,rightdesc,righttype) values (1736,'权限复制维护','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1736,7,'权限复制维护','权限复制维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1736,8,'HrmRrightCopy','HrmRrightCopy') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1736,9,'權限複製維護','權限複製維護') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42967,'权限复制','HrmRrightCopy:copy',1736) 
GO
