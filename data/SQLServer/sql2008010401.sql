insert into SystemRights (id,rightdesc,righttype) values (771,'流程监控设置','5') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (771,8,'Workflow monitor setting','Workflow monitor setting') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (771,7,'流程监控设置','流程监控设置') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4280,'流程监控设置','WorkflowMonitor:All',771) 
GO
