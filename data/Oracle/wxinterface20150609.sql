create table wx_basesetting (
   id               integer              null,
   wxsysurl			varchar(1000)        null,
   userkeytype      varchar(100)         null,
   accesstoken      varchar(200)         null,
   outsysid         varchar(200)         null,
   ctimeout         varchar(200)         null,
   stimeout         varchar(200)         null
)
/

create sequence WX_BASESETTING_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WX_BASESETTING_id_trigger
before insert on wx_basesetting
for each row
begin
select WX_BASESETTING_id.nextval into :new.id from dual;
end;
/
