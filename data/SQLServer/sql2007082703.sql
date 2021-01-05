alter table  leftmenuinfo add refersubid int default -1 /*-1:没有引用 0:总部引用  大于0:表示*/
GO
alter table  mainmenuinfo add refersubid int default -1
GO