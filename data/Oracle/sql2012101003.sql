create table mode_customtree(
	id integer not null,
	treename varchar2(200),
	treedesc varchar2(4000),
	modeid integer,
	creater integer,
	createdate varchar2(10),
	createtime varchar2(8),
	rootname varchar2(100),
	rooticon varchar2(1000)
)
/
create sequence mode_customtree_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_customtree_Tri
before insert on mode_customtree
for each row
begin
select mode_customtree_id.nextval into :new.id from dual;
end;
/
create table mode_customtreedetail(
	id integer not null,
	mainid integer,
	nodename varchar2(200),
	nodedesc varchar2(4000),
	sourcefrom integer,
	sourceid integer,
	tablename varchar2(100),
	tablekey varchar2(100),
	tablesup varchar2(100),
	showfield varchar2(100),
	hreftype integer,
	hrefid integer,
	hreftarget varchar2(4000),
	hrefrelatefield varchar2(100),
	nodeicon varchar2(1000),
	supnode integer,
	supnodefield varchar2(100),
	nodefield varchar2(100),
	showorder number(15,2)
)
/
create sequence mode_customtreedetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_customtreedetail_Tri
before insert on mode_customtreedetail
for each row
begin
select mode_customtreedetail_id.nextval into :new.id from dual;
end;
/

create table mode_dataapprovalinfo(
	id integer not null,
	billid integer,
	modeid integer,
	formid integer,
	requestid integer,
	operator integer,
	operatedate varchar2(10),
	operatetime varchar2(8),
	approvalstatus integer,
	approvaldate varchar2(10),
	approvaltime varchar2(8)
)
/
create sequence mode_dataapprovalinfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_dataapprovalinfo_Tri
before insert on mode_dataapprovalinfo
for each row
begin
select mode_dataapprovalinfo_id.nextval into :new.id from dual;
end;
/

alter table mode_triggerworkflowset add successwriteback varchar2(4000)
/
alter table mode_triggerworkflowset add failwriteback varchar2(4000)
/