delete from SystemRightDetail where rightid =1757
GO
delete from SystemRightsLanguage where id =1757
GO
delete from SystemRights where id =1757
GO
insert into SystemRights (id,rightdesc,righttype) values (1757,'���̽ӿڿ���','5') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1757,8,'Workflow Interface development','Workflow Interface development') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1757,7,'���̽ӿڿ���','���̽ӿڿ���') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1757,9,'���̽ӿ��_�l','���̽ӿ��_�l') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42990,'���̽ӿڿ���Ȩ��','Workflow:InterfaceDev',1757) 
GO


delete from SystemRightDetail where rightid =301
GO
delete from SystemRightsLanguage where id =301
GO
delete from SystemRights where id =301
GO

delete from SystemRightDetail where rightid =1749
GO
delete from SystemRightsLanguage where id =1749
GO
delete from SystemRights where id =1749
GO
insert into SystemRights (id,rightdesc,righttype) values (1749,'���̷���ά��','5') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,9,'���̷���S�o','���̷���S�o') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,7,'���̷���ά��','���̷���ά��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,8,'workflow Reverse maintenance','workflow Reverse 
maintenance') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42979,'���̷���ά��','Workflow:permission',1749) 