delete from SystemRightDetail where rightid =2150
/
delete from SystemRightsLanguage where id =2150
/
delete from SystemRights where id =2150
/
insert into SystemRights (id,rightdesc,righttype) values (2150,'��־���','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,7,'��־���','��־���') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,8,'tail:log','tail:log') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,9,'���I�O��','���I�O��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,16,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43376,'��־���','tail:log',2150) 
/