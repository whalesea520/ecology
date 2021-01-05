
delete from HtmlNoteIndex where id=4830 
GO
delete from HtmlNoteInfo where indexid=4830 
GO
INSERT INTO HtmlNoteIndex values(4830,'标签格式') 
GO
INSERT INTO HtmlNoteInfo VALUES(4830,'标签格式',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4830,'label format',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4830,'標簽格式',9) 
GO

delete from HtmlNoteIndex where id=4831 
GO
delete from HtmlNoteInfo where indexid=4831
GO
INSERT INTO HtmlNoteIndex values(4831,'如：[前缀]#,##0.00[后缀]') 
GO
INSERT INTO HtmlNoteInfo VALUES(4831,'如：[前缀]#,##0.00[后缀]',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4831,'example：[prefix]#,##0.00[suffix]',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4831,'如：[前綴]#,##0.00[後綴]',9) 
GO
