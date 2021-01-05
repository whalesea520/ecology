delete from HtmlLabelIndex where id=20157
go
delete from HtmlLabelInfo where indexid=20157
go
INSERT INTO HtmlLabelIndex values(20157,'IP不在考勤范围内，此次签到（签退）不计入考勤！') 
go
INSERT INTO HtmlLabelInfo VALUES(20157,'IP不在考勤范围内，此次签到（签退）不计入考勤！',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20157,'IP isn''t in schedule scope,this signing in(singing out) couldn''t be considered as schedule!',8) 
go
