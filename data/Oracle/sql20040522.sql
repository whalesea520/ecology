insert into SystemRights (id,rightdesc,righttype) values (436,'阅读文档日志报表','1') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (436,7,'阅读文档日志报表','阅读文档日志报表') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (436,8,'RpReadView','read document log info') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3126,'阅读文档日志报表','RpReadView:View',436) 
/

insert into SystemRightToGroup(groupid,rightid) values(2,436)
/
insert into SystemRightRoles(rightid,roleid,rolelevel) values(436,3,2)
/