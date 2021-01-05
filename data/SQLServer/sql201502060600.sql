delete from SystemRightDetail where rightid =34
GO
delete from SystemRightsLanguage where id =34
GO
delete from SystemRights where id =34
GO
insert into SystemRights (id,rightdesc,righttype) values (34,'权限调整','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (34,8,'HrmRrightTransfer','HrmRrightTransfer permission') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (34,7,'权限调整','权限调整的许可') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (120,'权限调整许可','HrmRrightTransfer:Tran',34) 
GO