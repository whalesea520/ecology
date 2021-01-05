alter table Prj_ProjectStatus add summary varchar2(2000)
/
alter table Prj_ProjectStatus add dsporder decimal(10,2)
/
alter table Prj_ProjectStatus add issystem char(1)
/
alter table Prj_ProjectStatus add guid1 char(36)
/
update Prj_ProjectStatus set dsporder=id ,issystem='1' where id>=0 and id<=7
/
create table prj_prjwfconf(
id int  not null,
wftype int null,
wfid int null,
formid int null,
prjtype int null,
isopen char(1),
isasync int null,
actname varchar2(200) null,
creater int null,
createdate char(10),
createtime char(8),
lastmoddate char(10),
lastmodtime char(8),
xmjl int null,
xgxm int null,
xmmb int null,
cus1 int null,
cus2 int null,
cus3 int null,
cus4 int null,
cus5 int null,
cus6 int null,
cus7 int null,
cus8 int null
)
/
create sequence prj_prjwfconf_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger prj_prjwfconf_TRIGGER before insert on prj_prjwfconf for each row 
begin 
	select prj_prjwfconf_ID.nextval into :new.id from dual; 
end;
/


create table prj_prjwffieldmap(
id int  not null,
mainid int null,
fieldtype int null,
fieldid int null,
fieldname varchar(50) null
)
/
create sequence prj_prjwffieldmap_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger prj_prjwffieldmap_TRIGGER before insert on prj_prjwffieldmap for each row 
begin 
	select prj_prjwffieldmap_ID.nextval into :new.id from dual; 
end;
/
