create table wx_token (
   id         integer              null,
   userid     varchar(60)          null,
   token      varchar(32)          null,
   createdate varchar(19)          null
)
/
create sequence WX_TOKEN_ID
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WX_TOKEN_ID_trigger
before insert on wx_token
for each row
begin
select WX_TOKEN_ID.nextval into :new.id from dual;
end;
/
