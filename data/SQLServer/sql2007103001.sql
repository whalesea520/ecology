delete from SystemRights where id=725
GO
delete from SystemRightsLanguage where id=725
GO
delete from SystemRightDetail where rightid=725
GO
insert into SystemRights (id,rightdesc,righttype) values (725,'协作类别设置','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (725,7,'协作类别设置','协作类别设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (725,8,'set collaboration type','set collaboration type') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4233,'协作类别设置','collaborationtype:edit',725) 
GO

delete from SystemRights where id=726
GO
delete from SystemRightsLanguage where id=726
GO
delete from SystemRightDetail where rightid=726
GO
insert into SystemRights (id,rightdesc,righttype) values (726,'协作区设置','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (726,7,'协作区设置','协作区设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (726,8,'set collaboration area','set collaboration area') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4235,'协作区设置','collaborationarea:edit',726) 
GO

delete from SystemRights where id=727
GO
delete from SystemRightsLanguage where id=727
GO
delete from SystemRightDetail where rightid=727
GO
insert into SystemRights (id,rightdesc,righttype) values (727,'协作监控','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (727,7,'协作监控','协作监控') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (727,8,'collaboration Manage','collaboration Manage') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4234,'协作监控','collaborationmanager:edit',727) 
GO