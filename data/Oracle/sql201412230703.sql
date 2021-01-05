create table workflow_browsertype(
   id int primary key,
   labelname varchar(255) not null,
   useable char(1) default 1,
   changeable char(1) default 0
)
/
create sequence browsertype_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create or replace trigger browsertype_Trigger before insert on workflow_browsertype for each row 
begin select  browsertype_id.nextval into :new.id from dual; end;
/
alter table workflow_browserurl add  typeid int default 13
/
alter table workflow_browserurl add  useable char(1) default 1
/
alter table workflow_browserurl add  orderid int
/
insert into workflow_browsertype(labelname,useable,changeable) values ('人员',1,0)
/
insert into workflow_browsertype(labelname,useable,changeable) values ('组织',1,0)
/
insert into workflow_browsertype(labelname,useable,changeable) values ('流程',1,0)
/
insert into workflow_browsertype(labelname,useable,changeable) values ('文档',1,0)
/
insert into workflow_browsertype(labelname,useable,changeable) values ('系统',1,0)
/
insert into workflow_browsertype(labelname,useable,changeable) values ('客户',1,0)
/
insert into workflow_browsertype(labelname,useable,changeable) values ('项目',1,0)
/
insert into workflow_browsertype(labelname,useable,changeable) values ('资产',1,0)
/
insert into workflow_browsertype(labelname,useable,changeable) values ('人事',1,0)
/
insert into workflow_browsertype(labelname,useable,changeable) values ('公文',1,0)
/
insert into workflow_browsertype(labelname,useable,changeable) values ('会议',1,0)
/
insert into workflow_browsertype(labelname,useable,changeable) values ('集成',1,0)
/
insert into workflow_browsertype(labelname,useable,changeable) values ('其他',1,0)
/