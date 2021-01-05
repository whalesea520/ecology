create table mode_selectitempage(
 id int primary key ,
 selectitemname varchar2(1000),
 selectitemdesc varchar2(1000),
 creater int,
 createdate varchar2(640),
 createtime varchar2(512),
 appid int
)
/

create table mode_selectitempagedetail(
id int primary key ,
mainid int not null,
name varchar2(1000),
disorder decimal(15,2),
defaultvalue varchar2(1000),
pathcategory varchar2(1000),
maincategory varchar2(1000),
isAccordToSubCom int,
pid int ,
statelev int
)
/

create sequence mode_selectitempage_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mode_selectitempage_id_Tri
before insert on mode_selectitempage
for each row
begin
select mode_selectitempage_id.nextval into :new.id from dual;
end;
/

create sequence mode_selectitempagedetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mode_selectitemdetail_id_Tri
before insert on mode_selectitempagedetail
for each row
begin
select mode_selectitempagedetail_id.nextval into :new.id from dual;
end;
/
alter table workflow_billfield add selectitem int
/
alter table workflow_billfield add linkfield int
/
insert into mode_fieldtype(id,typename,namelabel,classname,ifdetailuse,orderid,status) values('8','公共选择项','82477','weaver.formmode.field.SelectItemElement','1','21','1')
/
