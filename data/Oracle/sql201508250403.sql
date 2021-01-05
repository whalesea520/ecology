create table mode_batchmodify
(
  ID      INTEGER primary key not null,
  name    VARCHAR2(400),
  remark  VARCHAR2(4000),
  modeid  INTEGER,
  formid INTEGER
)
/
create table mode_batchmodifydetail
(
  ID         INTEGER primary key not null,
  MAINID     INTEGER,
  changetype INTEGER,
  feildid    INTEGER,
  feildvalue VARCHAR2(400)
)
/
create sequence mode_batchmodify_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create or replace trigger mode_batchmodify_Trigger before insert on mode_batchmodify for each row 
begin select mode_batchmodify_ID.nextval into :new.id from dual; end;
/
create sequence mode_batchmodifydetail_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create or replace trigger mode_batchmodifydetail_Trigger before insert on mode_batchmodifydetail for each row 
begin select mode_batchmodifydetail_ID.nextval into :new.id from dual; end;
/