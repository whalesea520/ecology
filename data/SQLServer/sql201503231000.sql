delete from SystemRightDetail where rightid =1833
GO
delete from SystemRightsLanguage where id =1833
GO
delete from SystemRights where id =1833
GO
insert into SystemRights (id,rightdesc,righttype) values (1833,'费用汇总表查看','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1833,10,'Сводная таблица расходов','Сводная таблица расходов') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1833,7,'费用汇总表查看','费用汇总表查看') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1833,8,'cost summary query','cost summary query') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1833,9,'費用彙總表查看','費用彙總表查看') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43064,'费用汇总表查看','costSummary:qry',1833) 
GO