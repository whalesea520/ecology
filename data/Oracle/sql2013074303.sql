CREATE TABLE OfUserRole ( 
    id integer not null,
    sharetype varchar(20),
    sharevalue varchar(200),
    tosharetype varchar(20),
    tosharevalue varchar(200)
) 
/
create sequence OfUserRole_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger OfUserRole_id_trigger
before insert on OfUserRole
for each row
begin
select OfUserRole_id.nextval into :new.id from dual;
end;
/