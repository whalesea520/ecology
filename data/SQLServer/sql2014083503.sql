CREATE table sms_reminder_mode(
  modekey VARCHAR(50) PRIMARY key,
  modename VARCHAR(200) not null
)
GO
CREATE table sms_reminder_type(
  type VARCHAR(50) PRIMARY key,
  typename VARCHAR(200) not null,
  modekey VARCHAR(50) not null
)
GO
CREATE table sms_reminder_set(
  id int NOT NULL IDENTITY(1,1) PRIMARY key,
  prefix VARCHAR(200) null,
  prefixConnector VARCHAR(10) null,
  suffix VARCHAR(200) null,
  suffixConnector VARCHAR(10) null,
  type VARCHAR(100) not null,
  def char(1) not null
)
GO
INSERT into sms_reminder_set(prefix,type,def) SELECT messageprefix,'ALL','1' FROM SystemSet
go
UPDATE sms_reminder_set set prefix=prefix+':' where prefix!='' and type='ALL' and def='1'
go