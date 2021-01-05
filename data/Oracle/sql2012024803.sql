create table wsactionset(
	id integer,
	actionname varchar2(200),
	workflowid integer,
	nodeid integer,
	nodelinkid integer,
	ispreoperator integer,
	inpara varchar2(200),
	actionorder integer,
	wsurl varchar2(400),
	wsoperation varchar2(100),
	xmltext long,
	rettype integer,
	retstr varchar2(2000)
)
/

create sequence wsactionset_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger wsactionset_id_Tri
before insert on wsactionset
for each row
begin
select wsactionset_id.nextval into :new.id from dual;
end;
/

create table sapactionset(
	id integer,
	actionname varchar2(200),
	workflowid integer,
	nodeid integer,
	nodelinkid integer,
	ispreoperator integer,
	actionorder integer,
	sapoperation varchar2(100)
)
/

create sequence sapactionset_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger sapactionset_id_Tri
before insert on sapactionset
for each row
begin
select sapactionset_id.nextval into :new.id from dual;
end;
/

create table sapactionsetdetail(
	id integer,
	mainid integer,
	type integer,
	paratype integer,
	paraname varchar2(100),
	paratext varchar2(2000)
)
/

create sequence sapactionsetdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger sapactionsetdetail_id_Tri
before insert on sapactionsetdetail
for each row
begin
select sapactionsetdetail_id.nextval into :new.id from dual;
end;
/

create view workflowactionview
as
	select d.id, d.dmlactionname as actionname, d.dmlorder as actionorder, d.nodeid, d.workflowId, d.nodelinkid, to_number(d.ispreoperator) as ispreoperator, 0 as actiontype
	from dmlactionset d
	union
	select w.id, w.actionname, w.actionorder, w.nodeid, w.workflowId, w.nodelinkid, w.ispreoperator, 1 as actiontype
	from wsactionset w
	union
	select s.id, s.actionname, s.actionorder, s.nodeid, s.workflowId, s.nodelinkid, s.ispreoperator, 2 as actiontype
	from sapactionset s
/
