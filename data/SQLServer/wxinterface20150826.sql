CREATE TABLE WX_SignCountLimit(
	id					int				IDENTITY,
	resourcetype		int				null,
	resourceids			varchar(2000)	null,
	countlimit			int				null,
	createtime			varchar(50)		null
	constraint PK_WX_SignCountLimit primary key (id)
)
go