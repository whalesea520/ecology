delete from SystemRightDetail where rightid =2068
GO
delete from SystemRightsLanguage where id =2068
GO
delete from SystemRights where id =2068
GO
insert into SystemRights (id,rightdesc,righttype) values (2068,'CoreMail����','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2068,7,'CoreMail����','CoreMail����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2068,8,'CoreMail','CoreMail') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2068,9,'CoreMail����','CoreMail����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2068,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2068,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2068,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2068,15,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43286,'CoreMail����','CoreMail:ALL',2068) 
GO