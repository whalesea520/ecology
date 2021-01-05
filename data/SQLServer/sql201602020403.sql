delete from social_IMSessionkey
GO
alter table social_IMSessionkey alter column userid int
GO
alter table social_IMSessionkey add loginStatus int
GO
alter table social_IMSessionkey add updateTime varchar(20)
GO