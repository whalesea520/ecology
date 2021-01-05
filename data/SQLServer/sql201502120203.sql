create table mode_selectitempage
(
 id int not null identity(1,1),
 selectitemname varchar(1000),
 selectitemdesc varchar(1000),
 creater int,
 createdate varchar(640),
 createtime varchar(512),
 appid int
)
GO
create table mode_selectitempagedetail
(
id int not null identity(1,1),
mainid int not null,
name varchar(1000),
disorder decimal(15,2),
defaultvalue varchar(1000),
pathcategory varchar(1000),
maincategory varchar(1000),
isAccordToSubCom int,
pid int ,
statelev int
)
GO
alter table workflow_billfield add selectitem int
go
alter table workflow_billfield add linkfield int
go
insert into mode_fieldtype(id,typename,namelabel,classname,ifdetailuse,orderid,status) values('8','公共选择项','82477','weaver.formmode.field.SelectItemElement','1','21','1')
go