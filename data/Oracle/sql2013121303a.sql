create table datashowset
(
  ID NUMBER(*,0) primary key NOT NULL ENABLE,
  showname varchar2(200),
  showclass char(1),
  datafrom char(1),
  datasourceid varchar2(100),
  sqltext varchar2(4000),
  wsurl varchar2(1000),
  wsoperation varchar2(1000),
  xmltext varchar2(4000),
  inpara varchar2(1000),
  showtype char(1),
  keyfield varchar2(100),
  parentfield varchar2(1000),
  showfield varchar2(1000),
  detailpageurl varchar2(1000)
) 
/
CREATE SEQUENCE datashowset_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger datashowset_Tri
  before insert on datashowset
  for each row
begin
  select datashowset_seq.nextval into :new.id from dual;
end;
/
alter table datashowset add typename char(1) 
/
alter table datashowset add selecttype char(1) 
/
alter table datashowset add showpageurl varchar2(200) 
/