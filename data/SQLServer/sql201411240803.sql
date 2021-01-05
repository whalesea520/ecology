delete from SystemRightDetail where rightid =1776
GO
delete from SystemRightsLanguage where id =1776
GO
delete from SystemRights where id =1776
GO
insert into SystemRights (id,rightdesc,righttype) values (1776,'登录前门户维护','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1776,8,'LoginPage Maintenance','LoginPage Maintenance') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1776,7,'登录前门户维护','登录前门户维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1776,9,'登錄前門戶維護','登錄前門戶維護') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43010,'登录前门户维护','LoginPageMaint',1776) 
GO
