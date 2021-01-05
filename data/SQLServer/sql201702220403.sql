create table hrm_sync_log(
id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
DataId       varchar(10),
Outkey       varchar(100),
DataType     int  ,
CreateDate  varchar(10),
CreateTime   varchar(8),
  delType int
)
GO