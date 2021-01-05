CREATE TABLE OfUserRoleExp ( 
    id integer not null,
    sharetype varchar(20),
    sharevalue varchar(200),
    tosharetype varchar(20),
    tosharevalue varchar(200)
) 
/
create sequence OfUserRoleExp_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger OfUserRoleExp_id_trigger
before insert on OfUserRoleExp
for each row
begin
select OfUserRoleExp_id.nextval into :new.id from dual;
end;
/
