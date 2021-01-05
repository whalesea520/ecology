CREATE TABLE ofmucusertoken ( 
    id integer not null,
    loginid varchar(100),
    clienttype integer,
    token varchar(200),
    userid varchar(200),
    channelid varchar(200)
) 
/
create sequence ofmucusertoken_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger ofmucusertoken_id_trigger
before insert on ofmucusertoken
for each row
begin
select ofmucusertoken_id.nextval into :new.id from dual;
end;
/

