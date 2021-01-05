create  INDEX docReadTag_user_in on docReadTag(userid,userType) 
GO

CREATE INDEX DOCSHAREDETAIL_USER_IN ON DOCSHAREDETAIL(USERID,USERTYPE)
GO

delete DOCSHAREDETAIL where userid in (select id from hrmresource where loginid='' or loginid is null )
GO
