CREATE TABLE SysDetachInfo ( 
    id integer PRIMARY KEY not null,
    name varchar(50),
    description varchar(200)
    ) 
/
create sequence SysDetachInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger SysDetachInfo_id_trigger
before insert on SysDetachInfo
for each row
begin
select SysDetachInfo_id.nextval into :new.id from dual;
end;
/

CREATE TABLE SysDetachDetail ( 
    id integer PRIMARY KEY not null,
    infoid integer not null,
    sourcetype integer,
    "type" integer,
    content varchar(50),
    seclevel int
    ) 
/
create sequence SysDetachDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger SysDetachDetail_id_trigger
before insert on SysDetachDetail
for each row
begin
select SysDetachDetail_id.nextval into :new.id from dual;
end;
/

CREATE TABLE SysDetachReport ( 
    id integer PRIMARY KEY not null,
    fromid integer not null,
    frominfoid integer not null,
    fromtype integer,
    fromcontent varchar(50),
    fromseclevel int,
    toid integer not null,
    toinfoid integer not null,
    totype integer,
    tocontent varchar(50),
    toseclevel int
    ) 
/
create sequence SysDetachReport_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger SysDetachReport_id_trigger
before insert on SysDetachReport
for each row
begin
select SysDetachReport_id.nextval into :new.id from dual;
end;
/

ALTER Table SystemSet ADD (
  appdetachable integer
)
/
