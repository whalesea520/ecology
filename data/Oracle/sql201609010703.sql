create table docseccategoryimporthistory
(
  id                       INTEGER not null,
  filepath                 varchar(2000),
  operateuserid            INTEGER,
  successnum               INTEGER,
  failnum                  INTEGER,
  operatedate              varchar(15),
  operatetime              varchar(15),
  clientaddress            varchar(100)
)

/

create sequence docseccategoryimporthistory_id
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20

/

create or replace trigger docseccategoryimport_TRIGGER before insert on docseccategoryimporthistory for each row 
begin select docseccategoryimporthistory_id.nextval INTO :new.id from dual; end;

/


create table docseccategoryimportfaildetail
(
  id                       INTEGER not null,
  historyid                INTEGER,
  failrow               	INTEGER,
  failcol               	varchar(100),
  seccategoryname          varchar(1000),
  failreason               varchar(100)
)

/

create sequence docseccimportfail_id
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20

/

create or replace trigger docseccimportfail_TRIGGER before insert on docseccategoryimportfaildetail for each row 
begin select docseccimportfail_id.nextval INTO :new.id from dual; end;

/
