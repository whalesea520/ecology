insert into SystemRights (id,rightdesc,righttype) values (436,'阅读文档日志报表','1') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (436,7,'阅读文档日志报表','阅读文档日志报表') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (436,8,'RpReadView','read document log info') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3126,'阅读文档日志报表','RpReadView:View',436) 
GO

insert into SystemRightToGroup(groupid,rightid) values(2,436);
go
insert into SystemRightRoles(rightid,roleid,rolelevel) values(436,3,2)
go