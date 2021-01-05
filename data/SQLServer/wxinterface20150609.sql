create table wx_basesetting (
   id                   int                  identity,
   wxsysurl				varchar(1000)		 null,
   userkeytype			varchar(100)		 null,
   accesstoken			varchar(200)		 null,
   outsysid				varchar(200)	     null,
   ctimeout				varchar(200)		 null,
   stimeout				varchar(200)		 null
   constraint PK_WX_BASESETTING primary key (id)
)
go