CREATE	INDEX	IX_WORKPLANEDITLOG_WUU	ON	WORKPLANEDITLOG	(WORKPLANID,USERID,USERTYPE)
GO
CREATE	INDEX	IX_WORKPLANAPPDETAILLOG_WUU	ON	WORKPLANAPPDETAIL	(WORKID,APPWORKPLANID)
GO