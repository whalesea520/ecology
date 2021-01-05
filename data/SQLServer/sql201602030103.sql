alter table WorkPlanShareset add  jobtitleid varchar(500),joblevel int,joblevelvalue varchar(500),sjobtitleid varchar(500),sjoblevel int,sjoblevelvalue varchar(500)
GO
alter table WorkPlanShare add jobtitleid int,joblevel int,joblevelvalue varchar(500)
GO
alter table WorkPlanShareDetail add  joblevel int,joblevelvalue int
GO