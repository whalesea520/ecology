delete from SystemRightDetail where rightid =1756
GO
delete from SystemRightsLanguage where id =1756
GO
delete from SystemRights where id =1756
GO
insert into SystemRights (id,rightdesc,righttype) values (1756,'�ʼ�����','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1756,8,'Email Setting','Email Setting') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1756,7,'�ʼ�����','�ʼ�����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1756,9,'�]���O��','�]���O��') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42986,'�ʼ�ϵͳ����','email:sysSetting',1756) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42987,'�ʼ�ģ������','email:templateSetting',1756) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42988,'��ҵ��������','email:enterpriseSetting',1756) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42989,'����ռ�����','email:spaceSetting',1756) 
GO