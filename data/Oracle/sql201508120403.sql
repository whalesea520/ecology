update modeinfo t set t.modecode = (select sys_guid() from  modeinfo t1 where t1.id = t.id) where 
exists (select 1 from modeinfo t2 where t2.id = t.id) 
and (modecode is null or modecode = '') 
/