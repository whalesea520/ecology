alter table DocSecCategoryCusSearch add isCond char(1) default '0'
GO
alter table DocSecCategoryCusSearch add condColumnWidth int default 1
GO
update DocSecCategoryCusSearch set isCond = '0'
GO
update DocSecCategoryCusSearch set condColumnWidth=1
GO
