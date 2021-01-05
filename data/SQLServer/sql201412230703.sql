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
insert into workflow_browsertype(labelname,useable,changeable) values ('人员',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('组织',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('流程',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('文档',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('系统',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('客户',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('项目',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('资产',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('人事',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('公文',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('会议',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('集成',1,0)
GO
insert into workflow_browsertype(labelname,useable,changeable) values ('其他',1,0)
GO