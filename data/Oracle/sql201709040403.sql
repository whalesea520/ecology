create table social_imAllowWinDepart
(
  ID             INTEGER not null,
  PERMISSIONTYPE INTEGER,
  CONTENTS       INTEGER,
  SECLEVEL       INTEGER,
  SECLEVELMAX    INTEGER default 100,
  JOBTITLEID     VARCHAR2(1000),
  JOBLEVEL       INTEGER default 0,
  SCOPEID        VARCHAR2(800)
)
/
create or replace trigger social_imAllWinDepart_trigger 
before insert on social_imAllowWinDepart
for each row 
begin 
  select social_imAllWinDepart_seq.nextval into:new.id from dual;
end
/
create sequence social_imAllWinDepart_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/