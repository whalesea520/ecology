CREATE TABLE  sensitive_settings(
  id INT NOT NULL PRIMARY KEY,
  status int  default 0 NULL,
  handleWay varchar2(50) default '0' NULL ,
  remindUsers varchar2(100) default '1' NULL
)

/
create sequence sensitive_settings_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create or replace trigger sensitive_settings_id_TRIGGER
  before insert on sensitive_settings
  for each row
begin
  select sensitive_settings_id.nextval into :new.id from dual;
end;
/

insert into sensitive_settings(status,handleWay,remindUsers) values(0,'0','1')

/

CREATE TABLE  sensitive_words(
  id INT NOT NULL PRIMARY KEY,
  word varchar2(500) NULL
)

/
create sequence sensitive_words_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create or replace trigger sensitive_words_id_TRIGGER
  before insert on sensitive_words
  for each row
begin
  select sensitive_words_id.nextval into :new.id from dual;
end;
/

CREATE TABLE  sensitive_logs(
  id INT NOT NULL PRIMARY KEY,
  module varchar2(100) NULL,
  path varchar2(2000) NULL,
  doccontent varchar2(4000) NULL,
  sensitiveWords varchar2(4000) NULL,
  handleWay varchar2(50) NULL,
  userid int NULL,
  submitTime varchar2(50) NULL,
  clientAddress varchar2(50) NULL
)

/
create sequence sensitive_logs_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create or replace trigger sensitive_logs_id_TRIGGER
  before insert on sensitive_logs
  for each row
begin
  select sensitive_logs_id.nextval into :new.id from dual;
end;
/