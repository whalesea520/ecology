create sequence GP_ACCESSRESETLOG_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table GP_ACCESSRESETLOG
(
  id          INTEGER not null  primary KEY,
  scoreid     INTEGER,
  operator    INTEGER,
  operatedate VARCHAR2(20),
  operatetype INTEGER
)
/
