delete from SystemRightDetail where rightid =1431
/
delete from SystemRightsLanguage where id =1431
/
delete from SystemRights where id =1431
/
insert into SystemRights (id,rightdesc,righttype) values (1431,'集成管理','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1431,8,'Integrated management','Integrated management') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1431,7,'集成管理','集成管理') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1431,9,'集成管理','集成管理') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42686,'集成管理','IntegratedManagement:Maint',1431) 
/