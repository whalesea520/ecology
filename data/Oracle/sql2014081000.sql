delete from SystemRightDetail where rightid =1719
/
delete from SystemRightsLanguage where id =1719
/
delete from SystemRights where id =1719
/
insert into SystemRights (id,rightdesc,righttype) values (1719,'ͬ��LDAP����','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1719,8,'LDAP data synchronization','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1719,9,'ͬ��LDAP����','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1719,7,'ͬ��LDAP����','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42940,'ͬ��LDAP����','ExportHrmFromLdap:Edit',1719) 
/