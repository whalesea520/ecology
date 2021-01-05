alter table DocSecCategoryCusSearch add isCond char(1) default '0'
/
alter table DocSecCategoryCusSearch add condColumnWidth integer default 1
/
update DocSecCategoryCusSearch set isCond = '0'
/
update DocSecCategoryCusSearch set condColumnWidth=1
/
