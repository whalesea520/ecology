delete from HtmlLabelIndex where id=27609 
GO
delete from HtmlLabelInfo where indexid=27609 
GO
INSERT INTO HtmlLabelIndex values(27609,'培训活动开始日期必须小于或等于') 
GO
delete from HtmlLabelIndex where id=27610 
GO
delete from HtmlLabelInfo where indexid=27610 
GO
INSERT INTO HtmlLabelIndex values(27610,'和培训活动结束日期必须大于或等于') 
GO
INSERT INTO HtmlLabelInfo VALUES(27609,'培训活动开始日期必须小于或等于',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27609,'Training start date must be less than or equal to',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27609,'培訓活動開始日期必須小于或等于',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27610,'和培训活动结束日期必须大于等于',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27610,'and Training endDate must be greater than or equal to',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27610,'和培訓活動結束日期必須大于等于',9) 
GO