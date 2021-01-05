delete from SystemRightDetail where rightid =34
/
delete from SystemRightsLanguage where id =34
/
delete from SystemRights where id =34
/
insert into SystemRights (id,rightdesc,righttype) values (34,'权限调整','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (34,8,'HrmRrightTransfer','HrmRrightTransfer permission') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (34,7,'权限调整','权限调整的许可') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (120,'权限调整许可','HrmRrightTransfer:Tran',34) 
/