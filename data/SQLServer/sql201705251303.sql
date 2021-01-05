alter table MailDeleteFile add userid int
GO
alter table MailDeleteFile add optdate varchar(30)
GO
alter table MailDeleteFile add deletedate varchar(30)
GO
alter table MailDeleteFile add mailid varchar(4)
GO
alter table MailDeleteFile add operation varchar(2) default 0
GO
CREATE INDEX maildeletefile_operation ON MailDeleteFile(operation)
GO