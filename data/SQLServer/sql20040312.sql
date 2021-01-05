delete from SystemRightToGroup where rightid=124
go
insert into SystemRightToGroup (groupid,rightid) values (3,124) 
GO
delete from SystemRightRoles where rightid=124
GO 
insert into SystemRightRoles (rightid,roleid,rolelevel) values (124,4,'2') 
GO 
