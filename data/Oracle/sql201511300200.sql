delete from SystemRightDetail where rightid =1938
/
delete from SystemRightsLanguage where id =1938
/
delete from SystemRights where id =1938
/
insert into SystemRights (id,rightdesc,righttype) values (1938,'分配客户经理','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1938,7,'分配客户经理','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1938,8,'Assign account manager','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1938,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1938,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1938,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1938,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1938,9,'分配客戶經理','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43160,'分配客户经理','CRM:AssignManager',1938) 
/