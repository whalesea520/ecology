delete from HtmlLabelIndex where id=126255 
GO
delete from HtmlLabelInfo where indexid=126255 
GO
INSERT INTO HtmlLabelIndex values(126255,'请假时间必须大于等于30分钟') 
GO
INSERT INTO HtmlLabelInfo VALUES(126255,'请假时间必须大于等于30分钟',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126255,'Leavetime must more than 30 minutes',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126255,'請假時間必須大于等于30分鍾',9) 
GO