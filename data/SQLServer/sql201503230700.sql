delete from SystemRightDetail where rightid =1834
GO
delete from SystemRightsLanguage where id =1834
GO
delete from SystemRights where id =1834
GO
insert into SystemRights (id,rightdesc,righttype) values (1834,'费用预算细化表','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1834,10,'расходы бюджета истончение таблица просмотра','расходы бюджета истончение таблица просмотра') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1834,7,'费用预算细化表查看','费用预算细化表查看') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1834,8,'Budget detailed table query','Budget detailed table query') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1834,9,'費用預算細化表查看','費用預算細化表查看') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43065,'费用预算细化表','fnaRptBudgetDetailed:qry',1834) 
GO