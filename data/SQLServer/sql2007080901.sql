delete from HtmlLabelIndex where id in(20770,20771,20772)
GO
delete from HtmlLabelInfo where indexId in(20770,20771,20772)
GO
INSERT INTO HtmlLabelIndex values(20770,'字符串六') 
GO
INSERT INTO HtmlLabelIndex values(20772,'部门单独流水') 
GO
INSERT INTO HtmlLabelIndex values(20771,'字符串七') 
GO
INSERT INTO HtmlLabelInfo VALUES(20770,'字符串六',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20770,'String Six',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20771,'字符串七',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20771,'String Seven',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20772,'部门单独流水',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20772,'Department Sequence Alone',8) 
GO
