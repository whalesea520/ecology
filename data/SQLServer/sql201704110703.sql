create table mailWorkRemindLog(
  id int IDENTITY,
  result bit default((0)),
  createtime char(19),
  sendfrom varchar(100),
  sendto varchar(4000),
  sendcc varchar(4000),
  sendbcc varchar(4000),
  subject varchar(4000),
  content varchar(4000),
  errorInfo varchar(4000)
)
GO

alter table MailConfigureInfo add isRecordSuccessMailRemindLog int
GO

alter table MailConfigureInfo add clearMailRemindLogTimelimit int
GO

update MailConfigureInfo set isRecordSuccessMailRemindLog = 0
GO

update MailConfigureInfo set clearMailRemindLogTimelimit = 15
GO