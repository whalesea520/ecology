delete from SystemRightDetail where rightid =1260
/
delete from SystemRightsLanguage where id =1260
/
delete from SystemRights where id =1260
/
insert into SystemRights (id,rightdesc,righttype) values (1260,'流程测试权限','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1260,7,'流程测试权限','流程测试权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1260,9,'流程測試權限','流程測試權限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1260,8,'Workflow Test Authority','Workflow Test Authority') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42537,'测试流程删除','Delete:TestRequest',1260) 
/