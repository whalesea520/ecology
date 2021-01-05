delete from SystemRightDetail where rightid =1947
GO
delete from SystemRightsLanguage where id =1947
GO
delete from SystemRights where id =1947
GO
insert into SystemRights (id,rightdesc,righttype) values (1947,'资产应用设置','4') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,7,'资产应用设置','资产应用设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,9,'資產應用設定','資產應用設定') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1947,8,'Asset application settings','Asset application settings') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (21947,'资产应用设置','Cpt:AppSettings',1947) 
GO
delete from SystemRightDetail where rightid =1960
GO
delete from SystemRightsLanguage where id =1960
GO
delete from SystemRights where id =1960
GO
insert into SystemRights (id,rightdesc,righttype) values (1960,'资产标签打印','4') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,8,'Asset label printing','Asset label printing') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,9,'資產標籤列印','資產標籤列印') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,7,'资产标签打印','资产标签打印') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1960,13,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (21960,'资产标签打印','Cpt:LabelPrint',1960) 
GO
