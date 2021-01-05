create table outter_entrance_log
(
  id      int identity(1,1) not null,
  userid    int,
  sysid         varchar(1000),
  createdate    varchar(10),
  createtime    varchar(8)
)
GO



alter table outter_sys 
add 
  createdate varchar(10)
GO

alter table outter_sys 
add 
  createtime varchar(8)
GO

alter table outter_sys 
add 
  modifydate varchar(10)
GO

alter table outter_sys 
add 
  modifytime varchar(8)
GO

update outter_sys set createdate = convert(varchar(10), getdate(), 23), createtime = convert(varchar(8), getdate(), 24), 
modifydate = convert(varchar(10), getdate(), 23), modifytime = convert(varchar(8), getdate(), 24)
GO



alter table outter_account 
add 
  createdate varchar(10)
GO

alter table outter_account 
add 
  createtime varchar(8)
GO

alter table outter_account 
add 
  modifydate varchar(10)
GO

alter table outter_account 
add 
  modifytime varchar(8)
GO

update outter_account set createdate = convert(varchar(10), getdate(), 23), createtime = convert(varchar(8), getdate(), 24), 
modifydate = convert(varchar(10), getdate(), 23), modifytime = convert(varchar(8), getdate(), 24)
GO