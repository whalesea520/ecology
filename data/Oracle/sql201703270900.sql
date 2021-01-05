delete from SystemRightDetail where rightid =2068
/
delete from SystemRightsLanguage where id =2068
/
delete from SystemRights where id =2068
/
insert into SystemRights (id,rightdesc,righttype) values (2068,'CoreMail集成','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2068,7,'CoreMail集成','CoreMail集成') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2068,8,'CoreMail','CoreMail') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2068,9,'CoreMail集成','CoreMail集成') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2068,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2068,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2068,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2068,15,'','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43286,'CoreMail集成','CoreMail:ALL',2068) 
/