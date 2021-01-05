create table workflow_approvelog (
   requestid int not null,
   nodeid int not null,
   operator int not null,
   remark text,
   logdate varchar(10),
   logtime varchar(8)     
) 
GO
create index index_workflow_approvelog on workflow_approvelog(requestid)
GO

create table workflow_approveerrorlog(
   requestid int not null,
   nodeid int not null,
   operator int not null,
   errorremark text
)
GO