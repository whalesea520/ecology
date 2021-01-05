CREATE TABLE sap_broFieldtonew
(
       ID INTEGER PRIMARY KEY NOT NULL,
       oldfield  integer,
       newfield  integer,
       oldformid integer,
       newformid integer,
       type    integer
)
/
create sequence sq_sap_broFieldtonew
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_broFieldtonew
before insert on sap_broFieldtonew
for each row
begin
select sq_sap_broFieldtonew.nextval into :new.id from dual;
end;
/