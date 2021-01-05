delete from HtmlNoteIndex where id=4097 
GO
delete from HtmlNoteInfo where indexid=4097 
GO
INSERT INTO HtmlNoteIndex values(4097,'周期会议') 
GO
delete from HtmlNoteIndex where id=4098 
GO
delete from HtmlNoteInfo where indexid=4098 
GO
INSERT INTO HtmlNoteIndex values(4098,'是否确认提交') 
GO
INSERT INTO HtmlNoteInfo VALUES(4098,'是否确认提交',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4098,'Are you sure to submit',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4098,'是否確認提交',9) 
GO
INSERT INTO HtmlNoteInfo VALUES(4097,'周期会议',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4097,'Cycle Meeting',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4097,'週期會議',9) 
GO