alter table blog_sysSetting add makeUpTime varchar(5)
GO

update blog_sysSetting set makeUpTime = '3'
GO

alter table blog_sysSetting add canEditTime varchar(5)
GO

update blog_sysSetting set canEditTime = '5'
GO

alter table blog_share add canViewMinTime char(10) default ('-1')
GO

alter table blog_specifiedShare add canViewMinTime char(10) default ('-1')
GO

update blog_share set canViewMinTime = -1
GO

update blog_specifiedShare set canViewMinTime = -1
GO