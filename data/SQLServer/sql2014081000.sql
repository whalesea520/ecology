delete from SystemRightDetail where rightid =1719
GO
delete from SystemRightsLanguage where id =1719
GO
delete from SystemRights where id =1719
GO
insert into SystemRights (id,rightdesc,righttype) values (1719,'ͬ��LDAP����','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1719,8,'LDAP data synchronization','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1719,9,'ͬ��LDAP����','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1719,7,'ͬ��LDAP����','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42940,'ͬ��LDAP����','ExportHrmFromLdap:Edit',1719) 
GO