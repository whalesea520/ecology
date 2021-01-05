create table WX_MsgRuleSetting (
   id                   integer               null,
   name                 varchar(200)          null,
   type                 smallint              null,
   ifrepeat             smallint              null,
   typeids              varchar(4000)         null,
   flowsordocs          varchar(4000)         null,
   names                varchar(4000)         null,
   msgtpids             varchar(4000)         null,
   msgtpnames           varchar(4000)         null,
   freqtime             integer               null,
   lastscantime         varchar(20)           null
)
/

create sequence WX_MsgRuleSetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WX_MsgRuleSetting_id_trigger
before insert on WX_MsgRuleSetting
for each row
begin
select WX_MsgRuleSetting_id.nextval into :new.id from dual;
end;
/