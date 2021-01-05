delete from HtmlLabelIndex where id=15880 
/
delete from HtmlLabelInfo where indexid=15880 
/
INSERT INTO HtmlLabelIndex values(15880,'考勤') 
/
INSERT INTO HtmlLabelInfo VALUES(15880,'考勤',7) 
/
INSERT INTO HtmlLabelInfo VALUES(15880,'Schedule',8) 
/
INSERT INTO HtmlLabelInfo VALUES(15880,'Schedule',9) 
/

delete from HtmlNoteIndex where id=4680 
/
delete from HtmlNoteInfo where indexid=4680 
/
INSERT INTO HtmlNoteIndex values(4680,'今天是工作日，现在要签到吗？') 
/
INSERT INTO HtmlNoteInfo VALUES(4680,'今天是工作日，现在要签到吗？',7) 
/
INSERT INTO HtmlNoteInfo VALUES(4680,'IsWorkday,SignIn?',8) 
/
INSERT INTO HtmlNoteInfo VALUES(4680,'今天是工作日，現在要簽到嗎？',9) 
/

delete from HtmlLabelIndex where id=21974 
/
delete from HtmlLabelInfo where indexid=21974 
/
INSERT INTO HtmlLabelIndex values(21974,'上班') 
/
INSERT INTO HtmlLabelInfo VALUES(21974,'上班',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21974,'On Duty',8) 
/
INSERT INTO HtmlLabelInfo VALUES(21974,'On Duty',9) 
/

delete from HtmlLabelIndex where id=21975 
/
delete from HtmlLabelInfo where indexid=21975 
/
INSERT INTO HtmlLabelIndex values(21975,'下班') 
/
INSERT INTO HtmlLabelInfo VALUES(21975,'下班',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21975,'Off Duty',8) 
/
INSERT INTO HtmlLabelInfo VALUES(21975,'Off Duty',9) 
/

delete from HtmlLabelIndex where id=129011 
/
delete from HtmlLabelInfo where indexid=129011 
/
INSERT INTO HtmlLabelIndex values(129011,'已签到') 
/
INSERT INTO HtmlLabelInfo VALUES(129011,'已签到',7) 
/
INSERT INTO HtmlLabelInfo VALUES(129011,'Signed',8) 
/
INSERT INTO HtmlLabelInfo VALUES(129011,'已簽到',9) 
/

delete from HtmlLabelIndex where id=129013 
/
delete from HtmlLabelInfo where indexid=129013 
/
INSERT INTO HtmlLabelIndex values(129013,'已签退') 
/
INSERT INTO HtmlLabelInfo VALUES(129013,'已签退',7) 
/
INSERT INTO HtmlLabelInfo VALUES(129013,'Signed',8) 
/
INSERT INTO HtmlLabelInfo VALUES(129013,'已簽退',9) 
/