create table social_imForbitLogin
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
alter table social_imForbitLogin
  add primary key (ID)
  using index 
  pctfree 10
  initrans 2
  maxtrans 255
/
create or replace trigger social_imForbitLogin_trigger 
before insert on social_imForbitLogin
for each row 
begin 
  select social_imForbitLogin_seq.nextval into:new.id from dual;
end;
/
create sequence social_imForbitLogin_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/