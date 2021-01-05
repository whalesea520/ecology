update hpinfo set subcompanyid=1,creatorid=1,creatortype=3 where id in (1,2)
GO
update hplayout set usertype=3 where hpid in (1,2) and usertype=4
go
