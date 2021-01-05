delete from hrmrolemembers where  roleid=4 and resourceid=1
GO
delete from  systemrightroles where roleid=4 and rightid=22
GO
insert into hrmrolemembers (roleid,resourceid,rolelevel) values(4,1,2)
GO
insert into systemrightroles(rightid,roleid,rolelevel) values(22,4,2)
GO
