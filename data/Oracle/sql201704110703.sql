create table mailWorkRemindLog(
  id int primary key,
  result integer default 0,
  createtime char(19),
  sendfrom varchar2(100),
  sendto varchar2(4000),
  sendcc varchar2(4000),
  sendbcc varchar2(4000),
  subject varchar2(4000),
  content varchar2(4000),
  errorInfo varchar2(4000)
)
/

alter table MailConfigureInfo add isRecordSuccessMailRemindLog integer
/

alter table MailConfigureInfo add clearMailRemindLogTimelimit integer
/

update MailConfigureInfo set isRecordSuccessMailRemindLog = 0
/

update MailConfigureInfo set clearMailRemindLogTimelimit = 15
/