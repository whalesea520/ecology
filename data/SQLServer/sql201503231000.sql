delete from SystemRightDetail where rightid =1833
GO
delete from SystemRightsLanguage where id =1833
GO
delete from SystemRights where id =1833
GO
insert into SystemRights (id,rightdesc,righttype) values (1833,'���û��ܱ��鿴','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1833,10,'���ӧ�էߧѧ� ��ѧҧݧڧ�� ��ѧ���է��','���ӧ�էߧѧ� ��ѧҧݧڧ�� ��ѧ���է��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1833,7,'���û��ܱ��鿴','���û��ܱ��鿴') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1833,8,'cost summary query','cost summary query') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1833,9,'�M�Ï������鿴','�M�Ï������鿴') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43064,'���û��ܱ��鿴','costSummary:qry',1833) 
GO