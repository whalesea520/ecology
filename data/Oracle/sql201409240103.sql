update modeinfo set modecode = sys_guid() where modecode is null or modecode=''
/