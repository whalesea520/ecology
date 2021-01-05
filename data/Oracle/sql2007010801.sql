delete from HtmlLabelIndex where id=20157
/
delete from HtmlLabelInfo where indexid=20157
/
INSERT INTO HtmlLabelIndex values(20157,'IP不在考勤范围内，此次签到（签退）不计入考勤！') 
/
INSERT INTO HtmlLabelInfo VALUES(20157,'IP不在考勤范围内，此次签到（签退）不计入考勤！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20157,'IP isn''t in schedule scope,this signing in(singing out) couldn''t be considered as schedule!',8) 
/
