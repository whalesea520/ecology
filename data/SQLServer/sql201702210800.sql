delete from SystemRightDetail where rightid =2057
GO
delete from SystemRightsLanguage where id =2057
GO
delete from SystemRights where id =2057
GO
insert into SystemRights (id,rightdesc,righttype) values (2057,'�ͻ�Ӧ������ά��','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,7,'�ͻ�Ӧ������','�ͻ�Ӧ������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,9,'�͑������O��','�͑������O��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,8,'customer application settings','customer application settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,15,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43275,'�ͻ�-Ӧ������ά��Ȩ��','Customer:Settings',2057)
GO