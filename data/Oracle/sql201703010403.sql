create table HRMSCHEDULESIGNIMP
(
  id                 INTEGER not null,
  userid             INTEGER,
  usertype           CHAR(1),
  signtype           CHAR(1),
  signdate           CHAR(10),
  signtime           CHAR(8),
  clientaddress      VARCHAR2(1000),
  isincom            CHAR(1),
  signfrom           VARCHAR2(1000),
  longitude          VARCHAR2(1000),
  latitude           VARCHAR2(1000),
  addr               VARCHAR2(1000),
  wxsignaddress      VARCHAR2(1000),
  eb_deviceid        VARCHAR2(64),
  eb_deviceid_change INTEGER,
  importsql      VARCHAR2(400),
  impdatetime      VARCHAR2(400),
  suuid      VARCHAR2(400),
  uuid      VARCHAR2(400),
  delflag           CHAR(1)
)
/
create sequence HRMSCHEDULESIGNIMP_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 50
order
/
create or replace trigger HRMSCHEDULESIGNIMP_TRIGGER
  before insert on HRMSCHEDULESIGNIMP
  for each row
begin
  select HRMSCHEDULESIGNIMP_id.nextval into :new.id from dual;
end;
/
alter table HRMSCHEDULESIGN add  suuid VARCHAR2(400)
/