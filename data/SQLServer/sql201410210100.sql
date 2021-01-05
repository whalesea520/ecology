delete from SystemRightDetail where rightid =1757
GO
delete from SystemRightsLanguage where id =1757
GO
delete from SystemRights where id =1757
GO
insert into SystemRights (id,rightdesc,righttype) values (1757,'流程接口开发','5') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1757,8,'Workflow Interface development','Workflow Interface development') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1757,7,'流程接口开发','流程接口开发') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1757,9,'流程接口開發','流程接口開發') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42990,'流程接口开发权限','Workflow:InterfaceDev',1757) 
GO


delete from SystemRightDetail where rightid =301
GO
delete from SystemRightsLanguage where id =301
GO
delete from SystemRights where id =301
GO

delete from SystemRightDetail where rightid =1749
GO
delete from SystemRightsLanguage where id =1749
GO
delete from SystemRights where id =1749
GO
insert into SystemRights (id,rightdesc,righttype) values (1749,'流程反向维护','5') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,9,'流程反向維護','流程反向維護') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,7,'流程反向维护','流程反向维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,8,'workflow Reverse maintenance','workflow Reverse 
maintenance') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42979,'流程反向维护','Workflow:permission',1749) 
