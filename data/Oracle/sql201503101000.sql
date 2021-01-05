delete from SystemRightDetail where rightid =1825
/
delete from SystemRightsLanguage where id =1825
/
delete from SystemRights where id =1825
/
insert into SystemRights (id,rightdesc,righttype) values (1825,'预算总额表查询','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1825,8,'Total budget table','Total budget table') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1825,7,'预算总额表查询','预算总额表查询') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1825,9,'預算總額表查詢','預算總額表查詢') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1825,10,'Общая сумма бюджета, таблица','Общая сумма бюджета, таблица') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43057,'预算总额表','TotalBudgetTable:qry',1825) 
/