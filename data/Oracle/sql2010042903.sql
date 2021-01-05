delete from workflow_filetypeicon where extendname in('et')
/
insert into workflow_filetypeicon (extendname, iconpath, describe)
values ('et', 'et.gif', 'WPS ET ³ÌÐò')
/

alter table DocImageFile modify docfiletype varchar(2)
/
