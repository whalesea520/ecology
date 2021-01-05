delete from SystemRightDetail where rightid =2064
GO
delete from SystemRightsLanguage where id =2064
GO
delete from SystemRights where id =2064
GO
insert into SystemRights (id,rightdesc,righttype) values (2064,'资产变更','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2064,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2064,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2064,7,'资产变更','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2064,8,'capital info change','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2064,9,'资产变更','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2064,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2064,14,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43282,'资产变更','CptCapital:Change',2064) 
GO