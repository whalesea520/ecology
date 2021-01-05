update leftmenuinfo set parentid=0 where parentid='' or  parentid is null
GO
update mainmenuinfo set parentid=0 where parentid='' or  parentid is null
GO