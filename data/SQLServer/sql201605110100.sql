delete from SystemRightDetail where rightid =1979
GO
delete from SystemRightsLanguage where id =1979
GO
delete from SystemRights where id =1979
GO
insert into SystemRights (id,rightdesc,righttype) values (1979,'Ԥ�����Ȩ��','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1979,7,'Ԥ�����Ȩ��','Ԥ�����Ȩ��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1979,9,'�A�㾎�ƙ���','�A�㾎�ƙ���') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1979,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1979,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1979,8,'Budget authority','Budget authority') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1979,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1979,12,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43197,'Ԥ�����Ȩ��','BudgetAuthorityRule:edit',1979) 
GO


delete from systemrighttogroup where RIGHTid = 1979
GO
insert into systemrighttogroup (GROUPid, RIGHTid) values (4, 1979)
GO





delete from SystemRightDetail where rightid =1980
GO
delete from SystemRightsLanguage where id =1980
GO
delete from SystemRights where id =1980
GO
insert into SystemRights (id,rightdesc,righttype) values (1980,'Ԥ�����ֻ��Ȩ��','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1980,7,'Ԥ�����ֻ��Ȩ��','Ԥ�����ֻ��Ȩ��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1980,9,'�A�㾎���b�x����','�A�㾎���b�x����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1980,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1980,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1980,8,'Budget for read-only access','Budget for read-only access') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1980,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1980,12,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43198,'Ԥ�����ֻ��Ȩ��','BudgetAuthorityRule:readOnly',1980) 
GO


delete from systemrighttogroup where RIGHTid = 1980
GO
insert into systemrighttogroup (GROUPid, RIGHTid) values (4, 1980)
GO