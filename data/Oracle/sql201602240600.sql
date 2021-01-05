delete from SystemRightDetail where rightid =1947
/
delete from SystemRightsLanguage where id =1947
/
delete from SystemRights where id =1947
/
insert into SystemRights (id,rightdesc,righttype) values (1947,'资产应用设置','4') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,7,'资产应用设置','资产应用设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,9,'資產應用設定','資產應用設定') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,8,'Asset application settings','Asset application settings') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (21947,'资产应用设置','Cpt:AppSettings',1947) 
/
delete from SystemRightDetail where rightid =1960
/
delete from SystemRightsLanguage where id =1960
/
delete from SystemRights where id =1960
/
insert into SystemRights (id,rightdesc,righttype) values (1960,'资产标签打印','4') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,8,'Asset label printing','Asset label printing') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,9,'資產標籤列印','資產標籤列印') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,7,'资产标签打印','资产标签打印') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,13,'','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (21960,'资产标签打印','Cpt:LabelPrint',1960) 
/
