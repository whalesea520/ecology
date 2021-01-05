delete from SystemRightDetail where rightid =2000
/
delete from SystemRightsLanguage where id =2000
/
delete from SystemRights where id =2000
/
insert into SystemRights (id,rightdesc,righttype) values (2000,'已发生费用导入','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2000,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2000,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2000,7,'已发生费用导入','已发生费用导入') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2000,8,'Import costs have occurred','Import costs have occurred') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2000,9,'已發生費用導入','已發生費用導入') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2000,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2000,15,'','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43217,'已发生费用导入','FnaOccurredExpenseImport:Add',2000) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43218,'已发生费用导入','FnaOccurredExpenseImport:Add',2000) 
/
delete from systemrighttogroup where RIGHTid = 2000
/
insert into systemrighttogroup (GROUPid, RIGHTid) values (4, 2000)
/
