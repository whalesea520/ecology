delete from SystemRightDetail where rightid =2057
/
delete from SystemRightsLanguage where id =2057
/
delete from SystemRights where id =2057
/
insert into SystemRights (id,rightdesc,righttype) values (2057,'客户应用设置维护','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,7,'客户应用设置','客户应用设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,9,'客戶應用設置','客戶應用設置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,8,'customer application settings','customer application settings') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,15,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43275,'客户-应用设置维护权限','Customer:Settings',2057)
/