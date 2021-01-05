delete from HtmlNoteIndex where id=3998 
GO
delete from HtmlNoteInfo where indexid=3998 
GO
INSERT INTO HtmlNoteIndex values(3998,'批示语') 
GO
INSERT INTO HtmlNoteInfo VALUES(3998,'批示语',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(3998,'instructions',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(3998,'批示語',9) 
GO

delete from HtmlNoteIndex where id=3876 
GO
delete from HtmlNoteInfo where indexid=3876 
GO
INSERT INTO HtmlNoteIndex values(3876,'粘贴') 
GO
INSERT INTO HtmlNoteInfo VALUES(3876,'粘贴',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(3876,'Paste',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(3876,'粘貼',9) 
GO