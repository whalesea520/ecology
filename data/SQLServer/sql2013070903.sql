alter table SystemSet add  isaesencrypt int default 0
GO
alter table imagefile add  isaesencrypt int default 0
GO
alter table imagefile add  aescode varchar(200)
GO
alter table MailResourceFile add  isaesencrypt int default 0
GO
alter table MailResourceFile add  aescode varchar(200)
GO