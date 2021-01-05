delete from HtmlLabelIndex where id in(20770,20771,20772)
/
delete from HtmlLabelInfo where indexId in(20770,20771,20772)
/
INSERT INTO HtmlLabelIndex values(20770,'字符串六') 
/
INSERT INTO HtmlLabelIndex values(20772,'部门单独流水') 
/
INSERT INTO HtmlLabelIndex values(20771,'字符串七') 
/
INSERT INTO HtmlLabelInfo VALUES(20770,'字符串六',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20770,'String Six',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20771,'字符串七',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20771,'String Seven',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20772,'部门单独流水',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20772,'Department Sequence Alone',8) 
/
