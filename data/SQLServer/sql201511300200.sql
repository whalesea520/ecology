delete from SystemRightDetail where rightid =1938
GO
delete from SystemRightsLanguage where id =1938
GO
delete from SystemRights where id =1938
GO
insert into SystemRights (id,rightdesc,righttype) values (1938,'����ͻ�����','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1938,7,'����ͻ�����','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1938,8,'Assign account manager','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1938,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1938,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1938,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1938,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1938,9,'����͑�����','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43160,'����ͻ�����','CRM:AssignManager',1938) 
GO