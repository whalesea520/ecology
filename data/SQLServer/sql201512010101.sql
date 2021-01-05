delete from HtmlNoteIndex where id=4082 
GO
delete from HtmlNoteInfo where indexid=4082 
GO
INSERT INTO HtmlNoteIndex values(4082,'位置') 
GO
INSERT INTO HtmlNoteInfo VALUES(4082,'位置',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4082,'Location',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4082,'位置',9) 
GO

delete from HtmlLabelIndex where id=126181 
GO
delete from HtmlLabelInfo where indexid=126181 
GO
INSERT INTO HtmlLabelIndex values(126181,'暂无位置信息') 
GO
INSERT INTO HtmlLabelInfo VALUES(126181,'暂无位置信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126181,'No location Information',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126181,'暫無位置信息',9) 
GO

delete from HtmlLabelIndex where id=126182 
GO
delete from HtmlLabelInfo where indexid=126182 
GO
INSERT INTO HtmlLabelIndex values(126182,'尚未定位') 
GO
INSERT INTO HtmlLabelInfo VALUES(126182,'尚未定位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126182,'Has yet to locate',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126182,'尚未定位',9) 
GO
 
delete from HtmlLabelIndex where id=126183 
GO
delete from HtmlLabelInfo where indexid=126183 
GO
INSERT INTO HtmlLabelIndex values(126183,'正在获取') 
GO
INSERT INTO HtmlLabelInfo VALUES(126183,'正在获取',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126183,'Locating',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126183,'正在獲取',9) 
GO