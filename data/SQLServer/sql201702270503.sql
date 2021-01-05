create table outerdatawflog(
Id int primary key identity(1,1),
Outerdatawfid int,
Outkey varchar(100),
Workflowid int,
RequestId int,
Triggerflag int,
CreateDate varchar(10),
CreateTime varchar(8)
)
GO

alter table outerdatawfset add CreateDate varchar(10)
GO
alter table outerdatawfset add CreateTime varchar(10)
GO
alter table outerdatawfset add ModifyDate varchar(10)
GO
alter table outerdatawfset add ModifyTime varchar(10)
GO