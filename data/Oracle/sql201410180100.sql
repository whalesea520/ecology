delete from SystemRightDetail where rightid =1726
/
delete from SystemRightsLanguage where id =1726
/
delete from SystemRights where id =1726
/
insert into SystemRights (id,rightdesc,righttype) values (1726,'�ʼ����Ȩ��','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1726,7,'�ʼ����Ȩ��','�ʼ����Ȩ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1726,8,'E-mail monitoring right','E-mail monitoring right') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1726,9,'�]���O�ؙ���','�]���O�ؙ���') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42951,'�ʼ����Ȩ��','Email:monitor',1726) 
/