delete from SystemRightDetail where rightid =1738
GO
delete from SystemRightsLanguage where id =1738
GO
delete from SystemRights where id =1738
GO
insert into SystemRights (id,rightdesc,righttype) values (1738,'Ԥ��ݸ���������','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1738,9,'�A��ݸ���������','�A��ݸ���������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1738,7,'Ԥ��ݸ���������','Ԥ��ݸ���������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1738,8,'The budget draft batch import','The budget draft batch import') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42969,'Ԥ��ݸ���������','BudgetDraftBatchImport:imp',1738) 
GO



delete from SystemRightDetail where rightid =1739
GO
delete from SystemRightsLanguage where id =1739
GO
delete from SystemRights where id =1739
GO
insert into SystemRights (id,rightdesc,righttype) values (1739,'Ԥ��ݸ�������Ч','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1739,8,'The budget draft batch effect','The budget draft batch effect') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1739,7,'Ԥ��ݸ�������Ч','Ԥ��ݸ�������Ч') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1739,9,'�A��ݸ�������Ч','�A��ݸ�������Ч') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42970,'Ԥ��ݸ�������Ч','BudgetDraftBatchEffect:effect',1739) 
GO