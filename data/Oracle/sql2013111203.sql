CREATE TABLE ofmucroomfiles ( 
    id integer not null,
    roomid varchar(100),
    imagefileid varchar(60),
    loginid varchar(60),
    createtime varchar(60)
) 
/
create sequence ofmucroomfiles_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger ofmucroomfiles_id_trigger
before insert on ofmucroomfiles
for each row
begin
select ofmucroomfiles_id.nextval into :new.id from dual;
end;
/
