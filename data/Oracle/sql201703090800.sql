delete from SystemRightDetail where rightid =2064
/
delete from SystemRightsLanguage where id =2064
/
delete from SystemRights where id =2064
/
insert into SystemRights (id,rightdesc,righttype) values (2064,'�ʲ����','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2064,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2064,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2064,7,'�ʲ����','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2064,8,'capital info change','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2064,9,'�ʲ����','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2064,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2064,14,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43282,'�ʲ����','CptCapital:Change',2064) 
/