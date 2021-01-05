create table RtxSendMsgLog (
  Id int NOT NULL identity(1,1) primary key,
  Userid int,
  MsgType varchar(10),
  MsgUrl varchar(500),
  CreateDate varchar(10),
  CreateTime varchar(8)
)
GO