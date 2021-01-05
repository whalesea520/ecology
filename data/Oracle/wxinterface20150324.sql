create table WX_LocationSetting (
   id               integer              null,
   resourceids      varchar(4000)        null,
   resourcetype     smallint             null,
   address          varchar(500)         null,
   distance         integer              null,
   lat              varchar(200)         null,
   lng              varchar(200)         null,
   createtime       varchar(20)          null
)
/

create sequence WX_LocationSetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WX_LocationSetting_id_trigger
before insert on WX_LocationSetting
for each row
begin
select WX_LocationSetting_id.nextval into :new.id from dual;
end;
/
