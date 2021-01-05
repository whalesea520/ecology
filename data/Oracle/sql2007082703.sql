alter table  leftmenuinfo add refersubid integer default -1 /*-1:没有引用 0:总部引用  大于0:表示*/
/
alter table  mainmenuinfo add refersubid integer default -1
/