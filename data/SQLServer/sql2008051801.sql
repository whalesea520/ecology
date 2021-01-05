delete from HtmlLabelIndex where id=21508 
GO
delete from HtmlLabelInfo where indexid=21508 
GO
INSERT INTO HtmlLabelIndex values(21508,'您已对此调查进行过提交，不能重复提交此调查！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21508,'您已对此调查进行过提交，不能重复提交此调查！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21508,'This voting is submited, Don''t repeat.',8) 
GO