delete from HtmlNoteIndex where id=4685 
GO
delete from HtmlNoteInfo where indexid=4685 
GO
INSERT INTO HtmlNoteIndex values(4685,'不能使用数据库保留字作为字段名!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4685,'不能使用数据库保留字作为字段名!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4685,'Cannot use the database reserved word as field names!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4685,'不能使用資料庫保留字作為欄位名!',9) 
GO
