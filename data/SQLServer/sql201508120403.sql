update modeinfo  set modecode = (select replace(newid(),'-','') from  modeinfo t1 where t.id =t1.id ) 
from modeinfo t where exists (select 1 from modeinfo t2 where t2.id = t.id) and (modecode is null or modecode = '') 
go