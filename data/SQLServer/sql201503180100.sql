delete from SystemRightDetail where rightid =1829
GO
delete from SystemRightsLanguage where id =1829
GO
delete from SystemRights where id =1829
GO
insert into SystemRights (id,rightdesc,righttype) values (1829,'预算执行情况表','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,7,'预算执行情况表','预算执行情况表') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,10,'Таблица исполнения бюджета','Таблица исполнения бюджета') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,8,'The implementation of the budget table','The implementation of the budget table') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,9,'預算執行情況表','預算執行情況表') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43061,'预算执行情况表','fnaRptImplementation:qry',1829) 
GO