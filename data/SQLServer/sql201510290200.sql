delete from SystemRightDetail where rightid =1933
GO
delete from SystemRightsLanguage where id =1933
GO
delete from SystemRights where id =1933
GO
insert into SystemRights (id,rightdesc,righttype) values (1933,'Ԥ�������ʼ��Ȩ��','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1933,7,'Ԥ�������ʼ��Ȩ��','Ԥ�������ʼ��Ȩ��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1933,8,'Budget initialization operation permissions','Budget initialization operation permissions') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1933,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1933,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1933,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1933,9,'�A�������ʼ������','�A�������ʼ������') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43153,'Ԥ�������ʼ��Ȩ��','BudgetOperation:Restoration',1933) 
GO