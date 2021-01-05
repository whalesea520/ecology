delete from HtmlLabelIndex where id=129011 
GO
delete from HtmlLabelInfo where indexid=129011 
GO
INSERT INTO HtmlLabelIndex values(129011,'已签到') 
GO
INSERT INTO HtmlLabelInfo VALUES(129011,'已签到',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129011,'Already sign in',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129011,'已簽到',9) 
GO

delete from HtmlLabelIndex where id=129013 
GO
delete from HtmlLabelInfo where indexid=129013 
GO
INSERT INTO HtmlLabelIndex values(129013,'已签退') 
GO
INSERT INTO HtmlLabelInfo VALUES(129013,'已签退',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129013,'Has the sign out',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129013,'已簽退',9) 
GO
 
delete from HtmlNoteIndex where id=4677 
GO
delete from HtmlNoteInfo where indexid=4677 
GO
INSERT INTO HtmlNoteIndex values(4677,'已签到') 
GO
INSERT INTO HtmlNoteInfo VALUES(4677,'已签到',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4677,'Already sign in',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4677,'已簽到',9) 
GO

delete from HtmlNoteIndex where id=4678 
GO
delete from HtmlNoteInfo where indexid=4678 
GO
INSERT INTO HtmlNoteIndex values(4678,'已签退') 
GO
INSERT INTO HtmlNoteInfo VALUES(4678,'已签退',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4678,'Has the sign out',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4678,'已簽退',9) 
GO

delete from HtmlNoteIndex where id=4674 
GO
delete from HtmlNoteInfo where indexid=4674 
GO
INSERT INTO HtmlNoteIndex values(4674,'现在是工作时间，您确定要签退吗？') 
GO
INSERT INTO HtmlNoteInfo VALUES(4674,'现在是工作时间，您确定要签退吗？',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4674,'Now is the working time, you sure you want to sign and return it?',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4674,'現在是工作時間，您确定要簽退嗎？',9) 
GO

delete from HtmlNoteIndex where id=4675 
GO
delete from HtmlNoteInfo where indexid=4675 
GO
INSERT INTO HtmlNoteIndex values(4675,'你上个工作日没有提交工作微博,是否补交？') 
GO
INSERT INTO HtmlNoteInfo VALUES(4675,'你上个工作日没有提交工作微博,是否补交？',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4675,'You didn''''''''t submited work microblog of previous workday,do you want to submit?',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4675,'你上個工作日沒有提交工作微博,是否補交？',9) 
GO

delete from HtmlNoteIndex where id=4676 
GO
delete from HtmlNoteInfo where indexid=4676 
GO
INSERT INTO HtmlNoteIndex values(4676,'你今天还没有提交工作微博,是否提交?') 
GO
INSERT INTO HtmlNoteInfo VALUES(4676,'你今天还没有提交工作微博,是否提交?',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4676,'You didn''''''''t submited work microblog of totay,do you want to submit?',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4676,'你今天還沒有提交工作微博,是否提交?',9) 
GO