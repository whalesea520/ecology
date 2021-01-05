alter table docshare add  joblevel char(10) not null  DEFAULT '0'
GO
alter table docshare add  jobdepartment char(10) not null  DEFAULT '0'
GO
alter table docshare add  jobsubcompany char(10) not null  DEFAULT '0'
GO
alter table docshare add  jobids char(10) not null  DEFAULT '0'
GO

alter table shareinnerdoc add  joblevel char(10) not null  DEFAULT '0'
GO
alter table shareinnerdoc add  jobdepartment char(10) not null  DEFAULT '0'
GO
alter table shareinnerdoc add  jobsubcompany char(10) not null  DEFAULT '0'
GO


alter table ShareouterDoc add  joblevel char(10) not null  DEFAULT '0'
GO
alter table ShareouterDoc add  jobdepartment char(10) not null  DEFAULT '0'
GO
alter table ShareouterDoc add  jobsubcompany char(10) not null  DEFAULT '0'
GO
alter table ShareouterDoc add  jobids char(10) not null  DEFAULT '0'
GO