create table WX_LocationSetting (
   id                   int                  identity,
   resourceids			varchar(4000)		 null,
   resourcetype			int					 null,
   address				varchar(500)		 null,
   distance				int					 null,
   lat					varchar(200)         null,
   lng					varchar(200)         null,
   createtime			varchar(20)          null,
   constraint PK_WX_LOCATIONSETTING primary key (id)
)
go