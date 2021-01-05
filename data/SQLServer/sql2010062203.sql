alter table MailAccount add sendneedSSL char(1)
GO
alter table MailAccount add getneedSSL char(1)
GO
alter table SystemSet add needssl char(1)
GO
alter table SystemSet add popServerPort varchar(4) default '110'
GO
alter table SystemSet add smtpServerPort varchar(4) default '25'
GO
