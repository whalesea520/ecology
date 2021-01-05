alter table MailSetting add emlsavedays int
GO
update MailSetting set emlsavedays = 30 
GO

alter table SystemSet add emlsavedays int
GO
update SystemSet set emlsavedays = 30 
GO

alter table mailresource add emltime varchar(30)
GO
update mailresource set emltime = senddate
GO

alter table mailresource add haseml int default 1
GO
update mailresource set haseml = 1
GO