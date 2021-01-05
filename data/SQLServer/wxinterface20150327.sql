create table WX_SENDMSGLOG (
   id                   int                  identity,
   senduserid			int					 null,
   receiveuserids		varchar(4000)		 null,
   content				varchar(4000)		 null,
   ifsend				int					 null,
   errormsg				varchar(4000)		 null,
   createtime			varchar(20)          null
   constraint PK_WX_SENDMSGLOG primary key (id)
)
go