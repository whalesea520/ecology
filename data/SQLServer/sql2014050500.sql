delete from SystemRightDetail where rightid =1643
GO
delete from SystemRightsLanguage where id =1643
GO
delete from SystemRights where id =1643
GO
insert into SystemRights (id,rightdesc,righttype) values (1643,'����Ӧ������','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1643,9,'���ő����O��','���ő����O��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1643,7,'����Ӧ������','����Ӧ������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1643,8,'Sms Setting','Sms Setting') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42875,'����Ӧ������','Sms:Set',1643) 
GO