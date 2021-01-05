delete from SystemRightDetail where rightid =1999
go
delete from SystemRightsLanguage where id =1999
go
delete from SystemRights where id =1999
go
insert into SystemRights (id,rightdesc,righttype) values (1999,'资产入库验收','0') 
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1999,12,'','') 
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1999,8,'Acceptance of assets','Acceptance of assets') 
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1999,9,'資產入庫驗收','資產入庫驗收') 
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1999,13,'','') 
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1999,14,'','') 
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1999,15,'','') 
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1999,7,'资产入库验收','资产入库验收') 
go

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43216,'资产入库验收','CptCapital:InStockCheck',1999) 
go
insert into SystemRightRoles (rightid,Roleid,Rolelevel)  select 1999,roleid,Rolelevel from SystemRightRoles where rightid = 144
go