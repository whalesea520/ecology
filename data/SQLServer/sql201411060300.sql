delete from SystemRightDetail where rightid =1768
GO
delete from SystemRightsLanguage where id =1768
GO
delete from SystemRights where id =1768
GO
insert into SystemRights (id,rightdesc,righttype) values (1768,'预算成本中心维护','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1768,8,'Budget cost center maintenance','Budget cost center maintenance') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1768,7,'预算成本中心维护','预算成本中心维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1768,9,'預算成本中心維護','預算成本中心維護') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43003,'预算成本中心维护','BudgetCostCenter:maintenance',1768) 
GO

DELETE from systemrighttogroup where (GROUPid=4 and RIGHTid=1768) 
GO

insert into systemrighttogroup (GROUPid, RIGHTid) values (4, 1768)
GO