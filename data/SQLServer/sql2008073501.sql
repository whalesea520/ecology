delete from HtmlLabelIndex where id=21729 
GO
delete from HtmlLabelInfo where indexid=21729 
GO
INSERT INTO HtmlLabelIndex values(21729,'是否短息提醒') 
GO
delete from HtmlLabelIndex where id=21730 
GO
delete from HtmlLabelInfo where indexid=21730 
GO
INSERT INTO HtmlLabelIndex values(21730,'短息提醒内容') 
GO
INSERT INTO HtmlLabelInfo VALUES(21729,'是否短息提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21729,'Whether the information remind',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21730,'短息提醒内容',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21730,'Information remind content',8) 
GO