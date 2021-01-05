create table mode_custompage(
	id integer not null,
	customname varchar2(400),
	customdesc varchar2(400),
	creater integer,
	createdate varchar2(10),
	createtime varchar2(8)
)
/
create sequence mode_custompage_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_custompage_Tri
before insert on mode_custompage
for each row
begin
select mode_custompage_id.nextval into :new.id from dual;
end;
/

create table mode_custompagedetail(
	id integer not null,
	mainid integer not null,
	hrefname varchar2(400),
	hreftitle varchar2(400),
	hrefdesc varchar2(400),
	hrefaddress varchar2(2000),
	disorder number(15,2)
)
/
create sequence mode_custompagedetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_custompagedetail_Tri
before insert on mode_custompagedetail
for each row
begin
select mode_custompagedetail_id.nextval into :new.id from dual;
end;
/

create table mode_pageexpand(
	id integer not null,
	modeid integer,
	expendname varchar2(100),
	showtype integer,
	opentype integer,
	hreftype integer,
	hrefid integer,
	hreftarget varchar2(2000),
	showcondition clob,
	showconditioncn clob,
	isshow integer,
	showorder number(15,2),
	issystem integer,
	issystemflag integer
)
/
create sequence mode_pageexpand_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_pageexpand_Tri
before insert on mode_pageexpand
for each row
begin
select mode_pageexpand_id.nextval into :new.id from dual;
end;
/

create table mode_pageexpandtemplate(
	id integer not null,
	expendname varchar2(100),
	showtype integer,
	opentype integer,
	hreftype integer,
	hrefid integer,
	hreftarget varchar2(2000),
	isshow integer,
	showorder number(15,2),
	issystem integer,
	issystemflag integer
)
/
create sequence mode_pageexpandtemplate_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_pageexpandtemplate_Tri
before insert on mode_pageexpandtemplate
for each row
begin
select mode_pageexpandtemplate_id.nextval into :new.id from dual;
end;
/

insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) values('新建保存','2','3','0','0','','1','1','1','1')
/
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) values('编辑保存','2','3','0','0','','1','2','1','2')
/
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) values('查看编辑','2','3','0','0','','1','3','1','3')
/
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) values('查看共享','2','3','0','0','','1','4','1','4')
/
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) values('查看删除','2','3','0','0','','1','5','1','5')
/
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) values('监控删除','2','3','0','0','','1','6','1','6')
/

insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) select id,'新建保存','2','3','0','0','','1','1','1','1' from modeinfo
/
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) select id,'编辑保存','2','3','0','0','','1','2','1','2' from modeinfo
/
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) select id,'查看编辑','2','3','0','0','','1','3','1','3' from modeinfo
/
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) select id,'查看共享','2','3','0','0','','1','4','1','4' from modeinfo
/
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) select id,'查看删除','2','3','0','0','','1','5','1','5' from modeinfo
/
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) select id,'监控删除','2','3','0','0','','1','6','1','6' from modeinfo
/

create table mode_pageexpanddetail(
	id integer not null,
	mainid integer,
	interfacetype integer,
	interfacevalue varchar2(2000)
)
/
create sequence mode_pageexpanddetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_pageexpanddetail_Tri
before insert on mode_pageexpanddetail
for each row
begin
select mode_pageexpanddetail_id.nextval into :new.id from dual;
end;
/

create table mode_pagerelatefield(
  id integer not null,
  modeid integer,
  hreftype integer,
  hrefid integer
)
/
create sequence mode_pagerelatefield_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_pagerelatefield_Tri
before insert on mode_pagerelatefield
for each row
begin
select mode_pagerelatefield_id.nextval into :new.id from dual;
end;
/

create table mode_pagerelatefielddetail(
  id integer not null,
  mainid integer,
  modefieldname varchar2(100),
  hreffieldname varchar2(100)
)
/
create sequence mode_pagerelatefielddetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_pagerelatefielddetail_Tri
before insert on mode_pagerelatefielddetail
for each row
begin
select mode_pagerelatefielddetail_id.nextval into :new.id from dual;
end;
/