delete hrmgroupmembers where userid in (select id from hrmresource where status=5) 
/

update workflow_browserurl set browserurl='/systeminfo/BrowserMain.jsp?url=/meeting/meetingbrowser.jsp' where tablename='meeting' and columname='name'
/

