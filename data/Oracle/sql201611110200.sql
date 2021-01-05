delete from SystemRightDetail where rightid =2033
/
delete from SystemRightsLanguage where id =2033
/
delete from SystemRights where id =2033
/
insert into SystemRights (id,rightdesc,righttype) values (2033,'CAS集成','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2033,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2033,8,'CAS:ALL','CAS:ALL') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2033,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2033,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2033,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2033,9,'CAS集成','CAS集成') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2033,7,'CAS集成','CAS集成') 
/