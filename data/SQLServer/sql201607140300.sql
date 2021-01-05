delete from SystemRightDetail where rightid =2000
GO
delete from SystemRightsLanguage where id =2000
GO
delete from SystemRights where id =2000
GO
insert into SystemRights (id,rightdesc,righttype) values (2000,'已发生费用导入','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2000,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2000,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2000,7,'已发生费用导入','已发生费用导入') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2000,8,'Import costs have occurred','Import costs have occurred') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2000,9,'已發生費用導入','已發生費用導入') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2000,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2000,15,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43217,'已发生费用导入','FnaOccurredExpenseImport:Add',2000) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43218,'已发生费用导入','FnaOccurredExpenseImport:Add',2000) 
GO
delete from systemrighttogroup where RIGHTid = 2000
GO
insert into systemrighttogroup (GROUPid, RIGHTid) values (4, 2000)
GO
