insert into shareoutter (sysid,type,content,seclevel,seclevelmax,sharelevel) select t1.sysid,3 as type,-1 as content,0 as seclevel,100 as seclevelmax,-1 as sharelevel from outter_sys t1 where not exists (select 1 from shareoutter t2 where t1.sysid=t2.sysid)
/