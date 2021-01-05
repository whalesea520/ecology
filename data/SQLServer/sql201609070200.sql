delete from SystemRightDetail where rightid =2014
GO
delete from SystemRightsLanguage where id =2014
GO
delete from SystemRights where id =2014
GO
insert into SystemRights (id,rightdesc,righttype) values (2014,'小e助手问题库','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2014,8,'e assistant faq','e assistant faq') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2014,7,'小e助手问题库','小e助手问题库') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2014,9,'小e助手問題庫','小e助手問題庫') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43232,'问题库','eAssistant:faq',2014) 
GO

delete from SystemRightDetail where rightid =2019
GO
delete from SystemRightsLanguage where id =2019
GO
delete from SystemRights where id =2019
GO
insert into SystemRights (id,rightdesc,righttype) values (2019,'小e助手固定指令设置','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2019,7,'小e助手固定指令设置','小e助手固定指令设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2019,9,'小e助手固定指令設置','小e助手固定指令設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2019,8,'e assistant fixedInst','e assistant fixedInst') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43237,'固定指令设置','eAssistant:fixedInst',2019) 
GO

delete from SystemRightDetail where rightid =2018
GO
delete from SystemRightsLanguage where id =2018
GO
delete from SystemRights where id =2018
GO
insert into SystemRights (id,rightdesc,righttype) values (2018,'小e助手客服设置','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2018,7,'小e助手客服设置','小e助手客服设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2018,8,'e assistant service','e assistant service') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2018,9,'小e助手客服設置','小e助手客服設置') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43236,'客服设置','eAssistant:server',2018) 
GO
delete from SystemRightDetail where rightid =2017
GO
delete from SystemRightsLanguage where id =2017
GO
delete from SystemRights where id =2017
GO
insert into SystemRights (id,rightdesc,righttype) values (2017,'小e助手人员库','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2017,8,'e assistant rsc','e assistant rsc') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2017,9,'小e助手人員庫','小e助手人員庫') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2017,7,'小e助手人员库','小e助手人员库') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43235,'人员库','eAssistant:rsc',2017) 
GO
delete from SystemRightDetail where rightid =2016
GO
delete from SystemRightsLanguage where id =2016
GO
delete from SystemRights where id =2016
GO
insert into SystemRights (id,rightdesc,righttype) values (2016,'小e助手客户库','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2016,7,'小e助手客户库','小e助手客户库') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2016,9,'小e助手客戶庫','小e助手客戶庫') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2016,8,'e assistant crm','e assistant crm') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43234,'客户库','eAssistant:crm',2016) 
GO
 
delete from SystemRightDetail where rightid =2015
GO
delete from SystemRightsLanguage where id =2015
GO
delete from SystemRights where id =2015
GO
insert into SystemRights (id,rightdesc,righttype) values (2015,'小e助手文档库','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2015,8,'e assistant doc','e assistant doc') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2015,7,'小e助手文档库','小e助手文档库') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2015,9,'小e助手文檔庫','小e助手文檔庫') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43233,'文档库','eAssistant:doc',2015) 
GO
 
