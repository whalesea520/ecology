delete from SystemRightDetail where rightid =2088
GO
delete from SystemRightsLanguage where id =2088
GO
delete from SystemRights where id =2088
GO
insert into SystemRights (id,rightdesc,righttype) values (2088,'CRM������Ϣ','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2088,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2088,8,'CRM business information','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2088,7,'CRM������Ϣ','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2088,9,'CRM������Ϣ','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2088,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2088,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2088,13,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43312,'CRM������Ϣ','crm:businessinfo',2088) 
GO