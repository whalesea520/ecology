create table mode_wsactionset(
	id integer,
	actionname varchar2(200),
	modeid integer,
	expandid integer,
	inpara varchar2(200),
	actionorder integer,
	wsurl varchar2(400),
	wsoperation varchar2(100),
	xmltext long,
	rettype integer,
	retstr varchar2(2000)
)
/

create sequence mode_wsactionset_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mode_wsactionset_id_Tri
before insert on mode_wsactionset
for each row
begin
select mode_wsactionset_id.nextval into :new.id from dual;
end;
/

create table mode_sapactionset(
	id integer,
	actionname varchar2(200),
	modeid integer,
	expandid integer,
	actionorder integer,
	sapoperation varchar2(100)
)
/

create sequence mode_sapactionset_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mode_sapactionset_id_Tri
before insert on mode_sapactionset
for each row
begin
select mode_sapactionset_id.nextval into :new.id from dual;
end;
/

create table mode_sapactionsetdetail(
	id integer,
	mainid integer,
	type integer,
	paratype integer,
	paraname varchar2(100),
	paratext varchar2(2000)
)
/

create sequence mode_sapactionsetdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mode_sapactionsetdetail_id_Tri
before insert on mode_sapactionsetdetail
for each row
begin
select mode_sapactionsetdetail_id.nextval into :new.id from dual;
end;
/

create table mode_dmlactionset
(
       id integer primary key not null,
       dmlactionname varchar2(200) not null,
       dmlorder integer,
		modeid integer,
		expandid integer,
       datasourceid varchar2(200),
       dmltype varchar(10)
)
/
CREATE SEQUENCE mode_dmlactionset_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger mode_dmlactionset_Tri
  before insert on mode_dmlactionset
  for each row
begin
  select mode_dmlactionset_seq.nextval into :new.id from dual;
end;
/
create table mode_dmlactionsqlset
(
       id integer primary key not null,
       actionid integer,
       actiontable varchar2(200),
       dmlformid integer,
       dmlformname varchar2(200),
       dmlisdetail integer,
       dmltablename varchar2(100),
       dmltablebyname varchar2(100),
       dmlsql varchar2(4000),
       dmlfieldtypes varchar2(4000),
       dmlfieldnames varchar2(4000),
       dmlothersql varchar2(4000),
       dmlotherfieldtypes varchar2(4000),
       dmlotherfieldnames varchar2(4000),
       dmlcuswhere varchar2(4000),
       dmlmainsqltype integer,
       dmlcussql varchar2(4000)
)
/
CREATE SEQUENCE mode_dmlactionsqlset_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger mode_dmlactionsqlset_Tri
  before insert on mode_dmlactionsqlset
  for each row
begin
  select mode_dmlactionsqlset_seq.nextval into :new.id from dual;
end;
/
create table mode_dmlactionfieldmap
(
       id integer primary key not null,
       actionsqlsetid integer,
       maptype char(1),
       fieldname varchar2(200),
       fieldvalue varchar2(200),
       fieldtype varchar2(200)
)
/
CREATE SEQUENCE mode_dmlactionfieldmap_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger mode_dmlactionfieldmap_Tri
  before insert on mode_dmlactionfieldmap
  for each row
begin
  select mode_dmlactionfieldmap_seq.nextval into :new.id from dual;
end;
/

create view mode_actionview
as
	select d.id, d.dmlactionname as actionname, d.dmlorder as actionorder, d.modeid, d.expandid, 0 as actiontype
	from mode_dmlactionset d
	union
	select w.id, w.actionname, w.actionorder, w.modeid, w.expandid, 1 as actiontype
	from mode_wsactionset w
	union
	select s.id, s.actionname, s.actionorder, s.modeid, s.expandid, 2 as actiontype
	from mode_sapactionset s
/