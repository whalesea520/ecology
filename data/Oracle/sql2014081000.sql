delete from SystemRightDetail where rightid =1719
/
delete from SystemRightsLanguage where id =1719
/
delete from SystemRights where id =1719
/
insert into SystemRights (id,rightdesc,righttype) values (1719,'同步LDAP数据','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1719,8,'LDAP data synchronization','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1719,9,'同步LDAP數據','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1719,7,'同步LDAP数据','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42940,'同步LDAP数据','ExportHrmFromLdap:Edit',1719) 
/