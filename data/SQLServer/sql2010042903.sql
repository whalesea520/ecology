delete from workflow_filetypeicon where extendname in('et')
go
insert into workflow_filetypeicon (extendname, iconpath, describe)
values ('et', 'et.gif', 'WPS ET ³ÌÐò')
go

alter table DocImageFile alter column docfiletype varchar(2) 
go
