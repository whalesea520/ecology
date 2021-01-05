alter table VotingShare add  joblevel char(10) not null  DEFAULT '0'
GO
alter table VotingShare add  jobdepartment char(10) not null  DEFAULT '0'
GO
alter table VotingShare add  jobsubcompany char(10) not null  DEFAULT '0'
GO
alter table VotingShare add  jobtitles char(10) not null  DEFAULT '0'
GO

alter table votingviewer add  joblevel char(10) not null  DEFAULT '0'
GO
alter table votingviewer add  jobdepartment char(10) not null  DEFAULT '0'
GO
alter table votingviewer add  jobsubcompany char(10) not null  DEFAULT '0'
GO
alter table votingviewer add  jobtitles char(10) not null  DEFAULT '0'
GO