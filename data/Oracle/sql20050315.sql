insert into SystemRights (id,rightdesc,righttype) values (461,'会议监控','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (461,7,'会议监控','会议监控') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (461,8,'meeting monitor','meeting monitor') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3153,'会议监控编辑','meetingmonitor:Edit',461) 
/
insert into SystemRightToGroup (groupid, rightid) values (13,461)
/
insert into systemrightroles(rightid,roleid,rolelevel) values (461,11,2)
/