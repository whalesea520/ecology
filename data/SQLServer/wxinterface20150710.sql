CREATE TABLE wx_locations(
	id					int			  IDENTITY,
	resourcetype		int			  null,
	resourceids			varchar(2000) null,
	resourceNames		varchar(2000) null,
	addressNames		varchar(2000) null,
	addressids			varchar(2000) null,
	createtime			varchar(30)   null,
	isenable			int			  null
	constraint PK_WX_LOCATIONS primary key (id)
)
go