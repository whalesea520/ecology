delete from SystemRightDetail where rightid =34
GO
delete from SystemRightsLanguage where id =34
GO
delete from SystemRights where id =34
GO
insert into SystemRights (id,rightdesc,righttype) values (34,'Ȩ�޵���','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (34,8,'HrmRrightTransfer','HrmRrightTransfer permission') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (34,7,'Ȩ�޵���','Ȩ�޵���������') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (120,'Ȩ�޵�������','HrmRrightTransfer:Tran',34) 
GO