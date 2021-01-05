delete from SystemRightDetail where rightid =1346
/
delete from SystemRightsLanguage where id =1346
/
delete from SystemRights where id =1346
/
insert into SystemRights (id,rightdesc,righttype) values (1346,'ldap人员维护','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1346,9,'ldap人員維護','ldap人員維護') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1346,7,'ldap人员维护','ldap人员维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1346,8,'ldap hrmresource manager','ldap hrmresource manager') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42623,'ldap人员维护','ldap:manager',1346) 
/