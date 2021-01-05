delete from hrmrolemembers where  roleid=4 and resourceid=1
/
delete from  systemrightroles where roleid=4 and rightid=22
/
insert into hrmrolemembers (roleid,resourceid,rolelevel) values(4,1,2)
/
insert into systemrightroles(rightid,roleid,rolelevel) values(22,4,2)
/
