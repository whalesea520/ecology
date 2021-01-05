delete from SystemRightDetail where rightid =1829
/
delete from SystemRightsLanguage where id =1829
/
delete from SystemRights where id =1829
/
insert into SystemRights (id,rightdesc,righttype) values (1829,'预算执行情况表','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,7,'预算执行情况表','预算执行情况表') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,10,'Таблица исполнения бюджета','Таблица исполнения бюджета') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,8,'The implementation of the budget table','The implementation of the budget table') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,9,'預算執行情況表','預算執行情況表') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43061,'预算执行情况表','fnaRptImplementation:qry',1829) 
/