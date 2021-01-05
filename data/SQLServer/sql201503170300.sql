delete from SystemRightDetail where rightid =1828
GO
delete from SystemRightsLanguage where id =1828
GO
delete from SystemRights where id =1828
GO
insert into SystemRights (id,rightdesc,righttype) values (1828,'费用查询统计表查询','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1828,10,'расходы запрос статистические таблицы запросов','расходы запрос статистические таблицы запросов') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1828,8,'The cost of query statistics table query','The cost of query statistics table query') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1828,7,'费用查询统计表查询','费用查询统计表查询') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1828,9,'費用查詢統計表查詢','費用查詢統計表查詢') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43060,'费用查询统计表查询','TheCostOfQueryStatistics:query',1828) 
GO