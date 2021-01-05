delete from SystemRightDetail where rightid =1508
/
delete from SystemRightsLanguage where id =1508
/
delete from SystemRights where id =1508
/
insert into SystemRights (id,rightdesc,righttype) values (1508,'证照管理后台维护','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1508,8,'License management background maintenance','License management background maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1508,7,'证照管理后台维护','证照管理后台维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1508,9,'證照管理後台維護','證照管理後台維護') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42753,'License:manager','证照管理后台维护',1508) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42754,'证照管理后台维护','License:manager',1508) 
/