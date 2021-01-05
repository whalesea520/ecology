delete from SystemRights where id=725
/
delete from SystemRightsLanguage where id=725
/
delete from SystemRightDetail where rightid=725
/
insert into SystemRights (id,rightdesc,righttype) values (725,'协作类别设置','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (725,7,'协作类别设置','协作类别设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (725,8,'set collaboration type','set collaboration type') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4233,'协作类别设置','collaborationtype:edit',725) 
/

delete from SystemRights where id=726
/
delete from SystemRightsLanguage where id=726
/
delete from SystemRightDetail where rightid=726
/
insert into SystemRights (id,rightdesc,righttype) values (726,'协作区设置','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (726,7,'协作区设置','协作区设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (726,8,'set collaboration area','set collaboration area') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4235,'协作区设置','collaborationarea:edit',726) 
/

delete from SystemRights where id=727
/
delete from SystemRightsLanguage where id=727
/
delete from SystemRightDetail where rightid=727
/
insert into SystemRights (id,rightdesc,righttype) values (727,'协作监控','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (727,7,'协作监控','协作监控') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (727,8,'collaboration Manage','collaboration Manage') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4234,'协作监控','collaborationmanager:edit',727) 
/