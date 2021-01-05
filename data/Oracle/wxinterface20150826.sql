create table WX_SignCountLimit (
   id               integer              null,
   resourcetype		integer				 null,
   resourceids      varchar(2000)        null,
   createtime       varchar(50)          null,
   countlimit		integer				 null
)
/

create sequence WX_SignCountLimit_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WX_SignCountLimit_id_trigger
before insert on WX_SignCountLimit
for each row
begin
select WX_SignCountLimit_id.nextval into :new.id from dual;
end;
/