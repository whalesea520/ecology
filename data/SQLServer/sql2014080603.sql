create table workflowtomodelog
(
  id int identity(1,1) primary key,
  typename varchar(32),
  modeid int,
  billid int ,
  mainid int,
  workflowid int
)
go
alter table mode_workflowtomodeset add formtype varchar(30)
go