create table wx_locations (
   id               integer              null,
   resourcetype		integer				 null,
   resourceids      varchar(2000)        null,
   resourceNames    varchar(2000)        null,
   addressNames     varchar(2000)        null,
   addressids       varchar(2000)        null,
   createtime       varchar(30)          null,
   isenable			integer				 null
)
/

create sequence WX_LOCATIONS_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WX_LOCATIONS_id_trigger
before insert on wx_locations
for each row
begin
select WX_LOCATIONS_id.nextval into :new.id from dual;
end;
/