delete from SystemRightDetail where rightid =1660
GO
delete from SystemRightsLanguage where id =1660
GO
delete from SystemRights where id =1660
GO
insert into SystemRights (id,rightdesc,righttype) values (1660,'预算设置权限','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1660,7,'预算设置权限','预算设置权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1660,9,'預算設置權限','預算設置權限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1660,8,'Budget organization structure is permission settings','Budget organization structure is permission settings') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) 
values (42890,'预算设置权限','BudgetOrgPermission:settings',1660) 
GO

delete from SystemRightDetail where rightid =1679
GO
delete from SystemRightsLanguage where id =1679
GO
delete from SystemRights where id =1679
GO
insert into SystemRights (id,rightdesc,righttype) values (1679,'费控方案','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1679,7,'费控方案','费控方案') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1679,9,'費控方案','費控方案') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1679,8,'fna control scheme','fna control scheme') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) 
values (42905,'费控方案','fnaControlScheme:set',1679) 
GO

delete from SystemRightDetail where rightid =1666
GO
delete from SystemRightsLanguage where id =1666
GO
delete from SystemRights where id =1666
GO
insert into SystemRights (id,rightdesc,righttype) values (1666,'费控流程设置','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1666,7,'费控流程设置','费控流程设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1666,8,'Cost control procedure','Cost control procedure') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1666,9,'費控流程設置','費控流程設置') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) 
values (42893,'费控流程设置','CostControlProcedure:set',1666) 
GO
