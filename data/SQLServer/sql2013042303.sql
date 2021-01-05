alter table MailResource add canview integer
GO
update MailResource set canview=1
GO