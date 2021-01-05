

update hpinfo set subcompanyid=1 where id in (1,2)
/
update hpinfo set creatorid=1 where id in (1,2)
/
update hpinfo set creatortype=3 where id in (1,2)
/
update hplayout set usertype=3 where hpid in (1,2) and usertype=4
/
