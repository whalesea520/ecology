create table WX_SETMSGLOG (
   id                   int              identity,
   userstrs				text			 null,
   requestid			int				 null,
   workflowid			int				 null,
   msgcode				varchar(100)	 null,
   errormsg				text			 null,
   createtime			varchar(20)      null
   constraint PK_WX_SETMSGLOG primary key (id)
)
go
create index WX_SETMSGLOG_Index_1 on WX_SETMSGLOG (
requestid ASC
)
go

create index WX_SETMSGLOG_Index_2 on WX_SETMSGLOG (
workflowid ASC
)
go