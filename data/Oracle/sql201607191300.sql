delete from SystemRightDetail where rightid =1999
/
delete from SystemRightsLanguage where id =1999
/
delete from SystemRights where id =1999
/
insert into SystemRights (id,rightdesc,righttype) values (1999,'资产入库验收','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1999,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1999,8,'Acceptance of assets','Acceptance of assets') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1999,9,'資產入庫驗收','資產入庫驗收') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1999,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1999,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1999,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1999,7,'资产入库验收','资产入库验收') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43216,'资产入库验收','CptCapital:InStockCheck',1999) 
/
insert into SystemRightRoles (rightid,Roleid,Rolelevel)  select 1999,roleid,Rolelevel from SystemRightRoles where rightid = 144
/