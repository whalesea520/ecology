delete from SystemRightDetail where rightid =1889
/
delete from SystemRightsLanguage where id =1889
/
delete from SystemRights where id =1889
/
insert into SystemRights (id,rightdesc,righttype) values (1889,'�鵵����','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1889,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1889,9,'�w�n����','�w�n����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1889,7,'�鵵����','�鵵����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1889,8,'exp','exp') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43118,'�鵵��������','exp:expsetting',1889) 
/