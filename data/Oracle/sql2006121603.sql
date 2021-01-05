create index leftmenuconfig_id on leftmenuconfig(id)
/
create index leftmenuconfig_infoid on leftmenuconfig(infoid,resourcetype,resourceid,userid,viewindex)
/

create index leftmenuinfo_id on leftmenuinfo(id,parentId,menuLevel,defaultIndex)
/
create index leftmenuinfo_parentid on leftmenuinfo(parentId,defaultIndex)
/
create index leftmenuinfo_menulevel on leftmenuinfo(menuLevel,defaultIndex)
/
