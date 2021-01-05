create table workflow_browsertype(
   id int identity(1,1) primary key,
   labelname varchar(255) not null,
   useable char(1) default 1,
   changeable char(1) default 0
)
GO
alter table workflow_browserurl add  typeid int default 13
GO
alter table workflow_browserurl add  useable char(1) default 1
GO
alter table workflow_browserurl add  orderid int
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('��Ա',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('��֯',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('����',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('�ĵ�',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('ϵͳ',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('�ͻ�',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('��Ŀ',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('�ʲ�',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('����',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('����',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('����',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('����',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('����',1,0)
GO