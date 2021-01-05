delete from SystemRightDetail where rightid =1961
/
delete from SystemRightsLanguage where id =1961
/
delete from SystemRights where id =1961
/
insert into SystemRights (id,rightdesc,righttype) values (1961,'预算手动结转','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,8,'Budget manual transfer','Budget manual transfer') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,7,'预算手动结转','预算手动结转') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,9,'預算手動結轉','預算手動結轉') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,13,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43181,'预算手动结转','BudgetManualTransfer:do',1961) 
/