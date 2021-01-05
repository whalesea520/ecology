insert into SystemRights (id,rightdesc,righttype) values (461,'会议监控','7') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (461,7,'会议监控','会议监控') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (461,8,'meeting monitor','meeting monitor') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3153,'会议监控编辑','meetingmonitor:Edit',461) 
GO

insert into SystemRightToGroup (groupid, rightid) values (13,461)
GO

insert into systemrightroles(rightid,roleid,rolelevel) values (461,11,2)
GO