create table RtxSyncDataLog (
  Id int NOT NULL identity(1,1) primary key,
  DataId varchar(100) NOT NULL,
  DataType varchar(10) NOT NULL,
  OperType varchar(10) NOT NULL,
  CreateDate varchar(10) NOT NULL,
  CreateTime varchar(8) NOT NULL
)
GO