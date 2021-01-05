delete from SystemRightDetail where rightid =2033
GO
delete from SystemRightsLanguage where id =2033
GO
delete from SystemRights where id =2033
GO
insert into SystemRights (id,rightdesc,righttype) values (2033,'CAS集成','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2033,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2033,8,'CAS:ALL','CAS:ALL') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2033,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2033,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2033,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2033,9,'CAS集成','CAS集成') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2033,7,'CAS集成','CAS集成') 
GO