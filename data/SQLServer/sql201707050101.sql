delete from HtmlNoteIndex where id=4772 
GO
delete from HtmlNoteInfo where indexid=4772 
GO
INSERT INTO HtmlNoteIndex values(4772,'�����ݳ�ʼ����ΧΪ����ʱ��{startdate}Ϊ���ܵ�һ�죬{enddate}Ϊ�������һ�졣') 
GO
INSERT INTO HtmlNoteInfo VALUES(4772,'�����ݳ�ʼ����ΧΪ����ʱ��{startdate}Ϊ���ܵ�һ�죬{enddate}Ϊ�������һ�졣',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4772,'When the data initialization range is this week, {startdate} is the first day of this week, and {enddate} is the last day of the week.',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4772,'��������ʼ�������鱾�L�r��{startdate}�鱾�L��һ�죬{enddate}�鱾�L����һ�졣',9) 
GO
delete from HtmlNoteIndex where id=4775 
GO
delete from HtmlNoteInfo where indexid=4775 
GO
INSERT INTO HtmlNoteIndex values(4775,'�����ݳ�ʼ����ΧΪ����ʱ�����������߼����ơ�') 
GO
INSERT INTO HtmlNoteInfo VALUES(4775,'�����ݳ�ʼ����ΧΪ����ʱ�����������߼����ơ�',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4775,'When the data initialization scope is other, follow the above logic analogy.',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4775,'��������ʼ�������������r����������߉݋��ơ�',9) 
GO