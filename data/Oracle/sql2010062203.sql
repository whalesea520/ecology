alter table MailAccount add sendneedSSL char(1)
/
alter table MailAccount add getneedSSL char(1)
/
alter table SystemSet add needssl char(1)
/
alter table SystemSet add popServerPort varchar2(4) default '110'
/
alter table SystemSet add smtpServerPort varchar2(4) default '25'
/
