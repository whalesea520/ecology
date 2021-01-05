delete from HtmlNoteIndex where id=4772 
GO
delete from HtmlNoteInfo where indexid=4772 
GO
INSERT INTO HtmlNoteIndex values(4772,'当数据初始化范围为本周时，{startdate}为本周第一天，{enddate}为本周最后一天。') 
GO
INSERT INTO HtmlNoteInfo VALUES(4772,'当数据初始化范围为本周时，{startdate}为本周第一天，{enddate}为本周最后一天。',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4772,'When the data initialization range is this week, {startdate} is the first day of this week, and {enddate} is the last day of the week.',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4772,'當數據初始化範圍為本週時，{startdate}為本週第一天，{enddate}為本週最後一天。',9) 
GO
delete from HtmlNoteIndex where id=4775 
GO
delete from HtmlNoteInfo where indexid=4775 
GO
INSERT INTO HtmlNoteIndex values(4775,'当数据初始化范围为其它时，按照上述逻辑类推。') 
GO
INSERT INTO HtmlNoteInfo VALUES(4775,'当数据初始化范围为其它时，按照上述逻辑类推。',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4775,'When the data initialization scope is other, follow the above logic analogy.',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4775,'當數據初始化範圍為其它時，按照上述邏輯類推。',9) 
GO