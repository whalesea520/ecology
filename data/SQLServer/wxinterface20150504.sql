CREATE TABLE wx_scanlog(
	id			int IDENTITY,
	type		int NULL,
	othertypes	int NULL,
	reourceid	int NULL,
	otherid		int NULL,
	scantime	varchar(20) NULL
	constraint PK_WX_SCANLOG primary key (id)
)
go
create table wx_initclass (
   id                   int					identity,
   classpath			varchar(500)		null
   constraint PK_WX_INITCLASS primary key (id)
)
go