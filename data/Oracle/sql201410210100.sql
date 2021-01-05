delete from SystemRightDetail where rightid =1757
/
delete from SystemRightsLanguage where id =1757
/
delete from SystemRights where id =1757
/
insert into SystemRights (id,rightdesc,righttype) values (1757,'流程接口开发','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1757,8,'Workflow Interface development','Workflow Interface development') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1757,7,'流程接口开发','流程接口开发') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1757,9,'流程接口開發','流程接口開發') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42990,'流程接口开发权限','Workflow:InterfaceDev',1757) 
/


delete from SystemRightDetail where rightid =301
/
delete from SystemRightsLanguage where id =301
/
delete from SystemRights where id =301
/

delete from SystemRightDetail where rightid =1749
/
delete from SystemRightsLanguage where id =1749
/
delete from SystemRights where id =1749
/
insert into SystemRights (id,rightdesc,righttype) values (1749,'流程反向维护','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,9,'流程反向維護','流程反向維護') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,7,'流程反向维护','流程反向维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,8,'workflow Reverse maintenance','workflow Reverse maintenance') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42979,'流程反向维护','Workflow:permission',1749) 
/