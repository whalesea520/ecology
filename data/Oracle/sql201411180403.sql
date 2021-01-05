CREATE TABLE hpOutDataTabSetting(
  id INTEGER PRIMARY key not null,
  eid INTEGER not null,
  tabid INTEGER NULL,
  title varchar(500) NULL,
  type varchar(1) NULL
)
/
CREATE SEQUENCE hpOutDataTabSetting_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger hpOutDataTabSetting_Tri
  before insert on hpOutDataTabSetting
  for each row
begin
  select hpOutDataTabSetting_seq.nextval into :new.id from dual;
end;
/

CREATE TABLE hpOutDataSettingField(
  id INTEGER PRIMARY key not null,
  eid INTEGER NULL,
  tabid INTEGER NULL,
  showfield varchar(500) NULL,
  showfieldname varchar(500) NULL,
  isshowname char(50) NULL,
  transql varchar(500) NULL,
  mainid INTEGER NULL
)
/
CREATE SEQUENCE hpOutDataSettingField_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger hpOutDataSettingField_Tri
  before insert on hpOutDataSettingField
  for each row
begin
  select hpOutDataSettingField_seq.nextval into :new.id from dual;
end;
/

CREATE TABLE hpOutDataSettingDef(
  id INTEGER PRIMARY key not null,
  pattern char(1) NULL ,
  source varchar(100) NULL ,
  area varchar(500) NULL ,
  dataKey varchar(50) NULL ,
  eid INTEGER NULL ,
  tabid INTEGER NULL ,
  wsaddress varchar(500) NULL ,
  wsmethod varchar(500) NULL ,
  wspara varchar(500) NULL ,
  href varchar(500) NULL ,
  sysaddr varchar(50) NULL 
)
/
CREATE SEQUENCE hpOutDataSettingDef_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger hpOutDataSettingDef_Tri
  before insert on hpOutDataSettingDef
  for each row
begin
  select hpOutDataSettingDef_seq.nextval into :new.id from dual;
end;
/

CREATE TABLE hpOutDataSettingAddr(
  id INTEGER PRIMARY key not null,
  eid INTEGER NOT NULL ,
  tabid INTEGER NULL ,
  sourceid INTEGER NULL ,
  address varchar(500) DEFAULT NULL ,
  pos INTEGER NULL
)
/
CREATE SEQUENCE hpOutDataSettingAddr_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger hpOutDataSettingAddr_Tri
  before insert on hpOutDataSettingAddr
  for each row
begin
  select hpOutDataSettingAddr_seq.nextval into :new.id from dual;
end;
/