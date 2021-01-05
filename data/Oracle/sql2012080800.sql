delete from SystemRightDetail where rightid =1297
/
delete from SystemRightsLanguage where id =1297
/
delete from SystemRights where id =1297
/
insert into SystemRights (id,rightdesc,righttype) values (1297,'模块设置','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1297,7,'模块设置','模块设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1297,8,'Mode Setting','Mode Setting') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1297,9,'模塊設置','模塊設置') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42573,'模块设置','ModeSetting:All',1297) 
/