delete from HtmlNoteIndex where id=14 
GO
delete from HtmlNoteInfo where indexid=14 
GO
INSERT INTO HtmlNoteIndex values(14,'必须项不能为空') 
GO
INSERT INTO HtmlNoteInfo VALUES(14,'必要信息不完整，红色叹号为必填项！',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(14,'Necessary information is not complete, the red exclamation point is required!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(14,'必要信息不完整，紅色歎号爲必填項！',9) 
GO