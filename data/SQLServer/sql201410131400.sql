delete from SystemRightDetail where rightid =1738
GO
delete from SystemRightsLanguage where id =1738
GO
delete from SystemRights where id =1738
GO
insert into SystemRights (id,rightdesc,righttype) values (1738,'预算草稿批量导入','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1738,9,'預算草稿批量導入','預算草稿批量導入') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1738,7,'预算草稿批量导入','预算草稿批量导入') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1738,8,'The budget draft batch import','The budget draft batch import') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42969,'预算草稿批量导入','BudgetDraftBatchImport:imp',1738) 
GO



delete from SystemRightDetail where rightid =1739
GO
delete from SystemRightsLanguage where id =1739
GO
delete from SystemRights where id =1739
GO
insert into SystemRights (id,rightdesc,righttype) values (1739,'预算草稿批量生效','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1739,8,'The budget draft batch effect','The budget draft batch effect') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1739,7,'预算草稿批量生效','预算草稿批量生效') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1739,9,'預算草稿批量生效','預算草稿批量生效') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42970,'预算草稿批量生效','BudgetDraftBatchEffect:effect',1739) 
GO