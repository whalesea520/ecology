delete from HtmlNoteIndex where id=98 
GO
delete from HtmlNoteInfo where indexid=98 
GO
INSERT INTO HtmlNoteIndex values(98,'科目对应期间已经存在变更，不能再进行添加') 
GO
INSERT INTO HtmlNoteInfo VALUES(98,'科目对应期间已经存在变更，不能再进行添加！',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(98,'subject has changed in budget period,can''''t insert.',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(98,'科目對應期間已經存在變更，不能再進行添加！',9) 
GO
INSERT INTO HtmlNoteInfo VALUES(98,'科目對應期間已經存在變更，不能再進行添加！',10) 
GO
