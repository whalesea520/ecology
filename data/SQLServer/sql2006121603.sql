create index leftmenuconfig_id on leftmenuconfig(id)
GO
create index leftmenuconfig_infoid on leftmenuconfig(infoid,resourcetype,resourceid,userid,viewindex)
GO

create index leftmenuinfo_id on leftmenuinfo(id,parentId,menuLevel,defaultIndex)
GO
create index leftmenuinfo_parentid on leftmenuinfo(parentId,defaultIndex)
GO
create index leftmenuinfo_menulevel on leftmenuinfo(menuLevel,defaultIndex)
GO
