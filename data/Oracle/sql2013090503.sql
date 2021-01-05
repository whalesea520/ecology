CREATE TABLE cpcchangenotice
(
       ID INTEGER PRIMARY KEY NOT NULL,
       c_companyid  INTEGER,
       c_type INTEGER,
       c_year  INTEGER,
       c_month INTEGER,
       c_time   varchar2(20),
       c_desc  varchar2(400)
)
/
create sequence sq_cpcchangenotice
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_cpcchangenotice
before insert on cpcchangenotice
for each row
begin
select sq_cpcchangenotice.nextval into :new.id from dual;
end;
/

