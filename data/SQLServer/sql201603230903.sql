alter table DirAccessControlList add  joblevel char(10) not null  DEFAULT '0'
GO
alter table DirAccessControlList add  jobdepartment char(10) not null  DEFAULT '0'
GO
alter table DirAccessControlList add  jobsubcompany char(10) not null  DEFAULT '0'
GO
alter table DirAccessControlList add  jobids char(10) not null  DEFAULT '0'
GO
alter table DirAccessControlDetail add  joblevel char(10) not null  DEFAULT '0'
GO
alter table DirAccessControlDetail add  jobdepartment char(10) not null  DEFAULT '0'
GO
alter table DirAccessControlDetail add  jobsubcompany char(10) not null  DEFAULT '0'
GO
alter table DirAccessControlDetail add  jobids char(10) not null  DEFAULT '0'
GO
alter table DocSecCategoryShare add  joblevel char(10) not null  DEFAULT '0'
GO
alter table DocSecCategoryShare add  jobdepartment char(10) not null  DEFAULT '0'
GO
alter table DocSecCategoryShare add  jobsubcompany char(10) not null  DEFAULT '0'
GO
alter table DocSecCategoryShare add  jobids char(10) not null  DEFAULT '0'
GO