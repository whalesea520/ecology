
delete from SystemRights where id=712
/
delete from SystemRightsLanguage where id=712
/
delete from SystemRightDetail where id=4220
/
insert into SystemRights (id,rightdesc,righttype) values (712,'管理索引权限','1')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (712,8,'IndexManager','IndexManager')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (712,7,'搜索索引管理','搜索索引管理')
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4220,'索引管理','searchIndex:manager',712)
/