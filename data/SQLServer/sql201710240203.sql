update Sys_fielddict set fieldname='hrmids' where fieldname='hrmid' and tabledictid =(select id from Sys_tabledict where tablename='MeetingRoom')
GO