create table wx_token (
   id                   int                  identity,
   userid               varchar(60)          null,
   token				varchar(32)          null,
   createdate           char(19)			 null,
   constraint PK_WX_TOKEN primary key (id)
)
go

