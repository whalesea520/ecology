create table WX_MsgRuleSetting (
   id                   int                  identity,
   name                 varchar(200)          null,
   type                 tinyint               null,
   ifrepeat             tinyint               null,
   typeids              varchar(4000)         null,
   flowsordocs          varchar(4000)         null,
   names                varchar(4000)         null,
   msgtpids             varchar(4000)         null,
   msgtpnames           varchar(4000)         null,
   freqtime             int                   null,
   lastscantime         varchar(20)           null,
   constraint PK_WX_MSGRULESETTING primary key (id)
)
go