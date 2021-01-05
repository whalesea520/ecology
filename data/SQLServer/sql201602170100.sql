delete from SystemRightDetail where rightid =1961
GO
delete from SystemRightsLanguage where id =1961
GO
delete from SystemRights where id =1961
GO
insert into SystemRights (id,rightdesc,righttype) values (1961,'预算手动结转','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,8,'Budget manual transfer','Budget manual transfer') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,7,'预算手动结转','预算手动结转') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,9,'預算手動結轉','預算手動結轉') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,13,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43181,'预算手动结转','BudgetManualTransfer:do',1961) 
GO