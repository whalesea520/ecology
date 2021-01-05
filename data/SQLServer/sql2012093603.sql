create table mode_custompage(
	id int identity,
	customname varchar(400),
	customdesc varchar(400),
	creater int,
	createdate varchar(10),
	createtime varchar(8)
)
go
create table mode_custompagedetail(
	id int identity,
	mainid int not null,
	hrefname varchar(400),
	hreftitle varchar(400),
	hrefdesc varchar(400),
	hrefaddress varchar(2000),
	disorder decimal(15,2)
)
go

create table mode_pageexpand(
	id int identity,
	modeid int,
	expendname varchar(100),
	showtype int,
	opentype int,
	hreftype int,
	hrefid int,
	hreftarget varchar(2000),
	showcondition text,
	showconditioncn text,
	isshow int,
	showorder decimal(15,2),
	issystem int,
	issystemflag int
)
go
create table mode_pageexpandtemplate(
	id int identity,
	expendname varchar(100),
	showtype int,
	opentype int,
	hreftype int,
	hrefid int,
	hreftarget varchar(2000),
	isshow int,
	showorder decimal(15,2),
	issystem int,
	issystemflag int
)
go

insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) values('新建保存','2','3','0','0','','1','1','1','1')
go
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) values('编辑保存','2','3','0','0','','1','2','1','2')
go
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) values('查看编辑','2','3','0','0','','1','3','1','3')
go
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) values('查看共享','2','3','0','0','','1','4','1','4')
go
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) values('查看删除','2','3','0','0','','1','5','1','5')
go
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) values('监控删除','2','3','0','0','','1','6','1','6')
go

insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) select id,'新建保存','2','3','0','0','','1','1','1','1' from modeinfo
go
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) select id,'编辑保存','2','3','0','0','','1','2','1','2' from modeinfo
go
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) select id,'查看编辑','2','3','0','0','','1','3','1','3' from modeinfo
go
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) select id,'查看共享','2','3','0','0','','1','4','1','4' from modeinfo
go
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) select id,'查看删除','2','3','0','0','','1','5','1','5' from modeinfo
go
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) select id,'监控删除','2','3','0','0','','1','6','1','6' from modeinfo
go

create table mode_pageexpanddetail(
	id int identity,
	mainid int,
	interfacetype int,
	interfacevalue varchar(2000)
)
go

create table mode_pagerelatefield(
	id int identity,
	modeid int,
	hreftype int,
	hrefid int
)
go

create table mode_pagerelatefielddetail(
	id int identity,
	mainid int,
	modefieldname varchar(100),
	hreffieldname varchar(100)
)
go