delete from SystemRightDetail where rightid =1776
/
delete from SystemRightsLanguage where id =1776
/
delete from SystemRights where id =1776
/
insert into SystemRights (id,rightdesc,righttype) values (1776,'登录前门户维护','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1776,8,'LoginPage Maintenance','LoginPage Maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1776,7,'登录前门户维护','登录前门户维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1776,9,'登錄前門戶維護','登錄前門戶維護') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43010,'登录前门户维护','LoginPageMaint',1776) 
/
