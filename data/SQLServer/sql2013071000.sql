delete from SystemRightDetail where rightid =1514
GO
delete from SystemRightsLanguage where id =1514
GO
delete from SystemRights where id =1514
GO
insert into SystemRights (id,rightdesc,righttype) values (1514,'项目附件设置权限','6') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1514,7,'项目附件设置权限','项目附件设置权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1514,8,'ProjectAccessoryConfiguration','ProjectAccessoryConfiguration') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1514,9,'项目附件设置权限','项目附件设置权限') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4081,'项目附件设置权限','Project maintenance',1514) 
GO
insert into SystemRightToGroup (groupid,rightid) values (7,1514)
GO