delete from SystemRightDetail where rightid =1947
/
delete from SystemRightsLanguage where id =1947
/
delete from SystemRights where id =1947
/
insert into SystemRights (id,rightdesc,righttype) values (1947,'�ʲ�Ӧ������','4') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,7,'�ʲ�Ӧ������','�ʲ�Ӧ������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,9,'�Y�a�����O��','�Y�a�����O��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,8,'Asset application settings','Asset application settings') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (21947,'�ʲ�Ӧ������','Cpt:AppSettings',1947) 
/
delete from SystemRightDetail where rightid =1960
/
delete from SystemRightsLanguage where id =1960
/
delete from SystemRights where id =1960
/
insert into SystemRights (id,rightdesc,righttype) values (1960,'�ʲ���ǩ��ӡ','4') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,8,'Asset label printing','Asset label printing') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,9,'�Y�a�˻`��ӡ','�Y�a�˻`��ӡ') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,7,'�ʲ���ǩ��ӡ','�ʲ���ǩ��ӡ') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,13,'','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (21960,'�ʲ���ǩ��ӡ','Cpt:LabelPrint',1960) 
/