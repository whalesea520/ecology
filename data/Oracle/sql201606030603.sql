create table hplayout_bak_dup  as select * from hplayout
/
delete from hplayout where exists(
select 1 from (
select  COUNT(1) c,min(id) tid,hpid hid,userid urid,areaflag aflag from hplayout  GROUP by hpid,areaflag,userid,usertype HAVING COUNT(1)>1 
) t where t.tid<id and t.hid=hpid and t.urid=userid and t.aflag=areaflag)
/
commit
/