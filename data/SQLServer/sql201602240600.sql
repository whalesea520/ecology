delete from SystemRightDetail where rightid =1947
GO
delete from SystemRightsLanguage where id =1947
GO
delete from SystemRights where id =1947
GO
insert into SystemRights (id,rightdesc,righttype) values (1947,'�ʲ�Ӧ������','4') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,7,'�ʲ�Ӧ������','�ʲ�Ӧ������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,9,'�Y�a�����O��','�Y�a�����O��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,8,'Asset application settings','Asset application settings') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (21947,'�ʲ�Ӧ������','Cpt:AppSettings',1947) 
GO
delete from SystemRightDetail where rightid =1960
GO
delete from SystemRightsLanguage where id =1960
GO
delete from SystemRights where id =1960
GO
insert into SystemRights (id,rightdesc,righttype) values (1960,'�ʲ���ǩ��ӡ','4') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,8,'Asset label printing','Asset label printing') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,9,'�Y�a�˻`��ӡ','�Y�a�˻`��ӡ') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,7,'�ʲ���ǩ��ӡ','�ʲ���ǩ��ӡ') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,13,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (21960,'�ʲ���ǩ��ӡ','Cpt:LabelPrint',1960) 
GO