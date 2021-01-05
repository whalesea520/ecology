create table workflow_approvelog (
   requestid int not null,
   nodeid int not null,
   operator int not null,
   remark clob,
   logdate varchar2(10),
   logtime varchar2(8)     
)
/
create index index_workflow_approvelog on workflow_approvelog(requestid)
/
create table workflow_approveerrorlog(
   requestid int not null,
   nodeid int not null,
   operator int not null,
   errorremark clob
)
/