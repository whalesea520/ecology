alter table mailaccount add isStartTls char(1)
GO

alter table webmail_domain add IS_START_TLS char(1)
GO

alter table systemset add mailIsStartTls char(1)
GO

alter table systemset add mailAccountName varchar(200)
GO