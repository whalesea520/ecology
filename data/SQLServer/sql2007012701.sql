insert into SystemRights (id,rightdesc,righttype) values (707,'日程监控设置','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (707,8,'WorkPlan Monitor Set','WorkPlan Monitor Set') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (707,7,'日程监控设置','日程监控设置') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4215,'日程监控设置','WorkPlanMonitorSet:Set',707) 
GO
