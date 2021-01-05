create table wsregiste
(
				id int primary key NOT NULL ,
        customcode varchar2(100),
        customname varchar2(100),
				webserviceurl varchar2(2000)
)
/
CREATE SEQUENCE wsregiste_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger wsregiste_Tri
  before insert on wsregiste
  for each row
begin
  select wsregiste_seq.nextval into :new.id from dual;
end;
/
create table wsregistemethod
(
	      id int primary key NOT NULL ,
        mainid int,
        methodname varchar2(200),
	      methoddesc varchar2(200),
	      methodreturntype varchar2(200)
)
/
CREATE SEQUENCE wsregistemethod_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger wsregistemethod_Tri
  before insert on wsregistemethod
  for each row
begin
  select wsregistemethod_seq.nextval into :new.id from dual;
end;
/
create table wsregistemethodparam
(
	      id int primary key NOT NULL ,
        methodid int,
        paramname varchar2(200),
        paramtype varchar2(200),
	      isarray char(1)
)
/
CREATE SEQUENCE wsregistemethodp_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger wsregistemethodp_Tri
  before insert on wsregistemethodparam
  for each row
begin
  select wsregistemethodp_seq.nextval into :new.id from dual;
end;
/
create table wsmethodparamvalue
(
	      id int primary key NOT NULL ,
	      contentid int,
	      contenttype int,
        methodid int,
        paramname varchar(200),
        paramtype varchar(200),
	      isarray char(1),
	      paramsplit varchar(10),
	      paramvalue varchar(4000)
)
/
CREATE SEQUENCE wsmethodparamvalue_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger wsmethodparamvalue_Tri
  before insert on wsmethodparamvalue
  for each row
begin
  select wsmethodparamvalue_seq.nextval into :new.id from dual;
end;
/
alter table financesetparam add transql varchar2(4000)
/