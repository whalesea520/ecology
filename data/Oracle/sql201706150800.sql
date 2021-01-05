delete from SystemRightDetail where rightid =2088
/
delete from SystemRightsLanguage where id =2088
/
delete from SystemRights where id =2088
/
insert into SystemRights (id,rightdesc,righttype) values (2088,'CRM工商信息','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2088,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2088,8,'CRM business information','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2088,7,'CRM工商信息','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2088,9,'CRM工商信息','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2088,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2088,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2088,13,'','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43312,'CRM工商信息','crm:businessinfo',2088) 
/