delete from SystemRightDetail where rightid =1719
GO
delete from SystemRightsLanguage where id =1719
GO
delete from SystemRights where id =1719
GO
insert into SystemRights (id,rightdesc,righttype) values (1719,'同步LDAP数据','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1719,8,'LDAP data synchronization','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1719,9,'同步LDAP數據','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1719,7,'同步LDAP数据','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42940,'同步LDAP数据','ExportHrmFromLdap:Edit',1719) 
GO