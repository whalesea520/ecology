delete from SystemRightDetail where rightid =1961
/
delete from SystemRightsLanguage where id =1961
/
delete from SystemRights where id =1961
/
insert into SystemRights (id,rightdesc,righttype) values (1961,'Ԥ���ֶ���ת','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,8,'Budget manual transfer','Budget manual transfer') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,7,'Ԥ���ֶ���ת','Ԥ���ֶ���ת') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,9,'�A���քӽY�D','�A���քӽY�D') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1961,13,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43181,'Ԥ���ֶ���ת','BudgetManualTransfer:do',1961) 
/