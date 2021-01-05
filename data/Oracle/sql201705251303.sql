alter table MailDeleteFile add userid int
/
alter table MailDeleteFile add optdate varchar(30)
/
alter table MailDeleteFile add deletedate varchar(30)
/
alter table MailDeleteFile add mailid varchar(4)
/
alter table MailDeleteFile add operation varchar(2) default 0
/
CREATE INDEX maildeletefile_operation ON MailDeleteFile(operation)
/