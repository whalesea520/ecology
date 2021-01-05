delete from SystemRightDetail where rightid =1297
/
delete from SystemRightsLanguage where id =1297
/
delete from SystemRights where id =1297
/
insert into SystemRights (id,rightdesc,righttype) values (1297,'表单建模模块管理','7')  
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1297,7,'表单建模模块管理','表单建模模块管理') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1297,8,'modeling of the form module management','modeling of the form module management') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1297,9,'表單建模模塊管理','表單建模模塊管理') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42573,'表单建模模块管理','ModeSetting:All',1297) 
/
update SystemRights set detachable=1 where id =1297
/
delete from SystemRightDetail where rightid =1796
/
delete from SystemRightsLanguage where id =1796
/
delete from SystemRights where id =1796
/
insert into SystemRights (id,rightdesc,righttype) values (1796,'表单建模应用管理','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1796,8,'application form model management','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1796,7,'表单建模应用管理','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1796,9,'表單建模應用管理','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43030,'表单建模应用管理','FORMMODEAPP:ALL',1796) 
/
update SystemRights set detachable=1 where id =1796
/
delete from SystemRightDetail where rightid =1797
/
delete from SystemRightsLanguage where id =1797
/
delete from SystemRights where id =1797
/
insert into SystemRights (id,rightdesc,righttype) values (1797,'表单建模表单管理','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1797,8,'form modeling forms management','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1797,7,'表单建模表单管理','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1797,9,'表單建模表單管理','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43031,'表单建模表单管理','FORMMODEFORM:ALL',1797) 
/
update SystemRights set detachable=1 where id =1797
/