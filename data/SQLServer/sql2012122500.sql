delete from SystemRightDetail where rightid =1417
GO
delete from SystemRightsLanguage where id =1417
GO
delete from SystemRights where id =1417
GO
insert into SystemRights (id,rightdesc,righttype) values (1417,'��������Ȩ��','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1417,7,'��������Ȩ��','��������Ȩ��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1417,8,'Financial set permissions','Financial set permissions') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1417,9,'ؔ���O�Ù���','ؔ���O�Ù���') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42672,'��������Ȩ��','FnaSystemSetEdit:Edit',1417) 
GO