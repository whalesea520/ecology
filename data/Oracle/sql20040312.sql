delete from SystemRightToGroup where rightid=124
/
insert into SystemRightToGroup (groupid,rightid) values (3,124) 
/
delete from SystemRightRoles where rightid=124
/
insert into SystemRightRoles (rightid,roleid,rolelevel) values (124,4,'2') 
/
