alter table WorkPlanShareset add (jobtitleid varchar2(500),joblevel int,joblevelvalue varchar2(500),sjobtitleid varchar2(500),sjoblevel int,sjoblevelvalue varchar2(500))
/
alter table WorkPlanShare add (jobtitleid int,joblevel int,joblevelvalue varchar2(500))
/
alter table WorkPlanShareDetail add (joblevel int,joblevelvalue int)
/