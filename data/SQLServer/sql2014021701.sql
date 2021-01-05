delete from HtmlLabelIndex where id=32643 
GO
delete from HtmlLabelInfo where indexid=32643 
GO
INSERT INTO HtmlLabelIndex values(32643,'实际打卡天数') 
GO
INSERT INTO HtmlLabelInfo VALUES(32643,'实际打卡天数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32643,'The actual time in days',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32643,'實際打卡天數',9) 
GO

delete from HtmlLabelIndex where id=32648 
GO
delete from HtmlLabelInfo where indexid=32648 
GO
INSERT INTO HtmlLabelIndex values(32648,'补签明细') 
GO
INSERT INTO HtmlLabelInfo VALUES(32648,'补签明细',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32648,'Retroactive details',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32648,'補簽明細',9) 
GO

delete from HtmlLabelIndex where id=32649 
GO
delete from HtmlLabelInfo where indexid=32649 
GO
INSERT INTO HtmlLabelIndex values(32649,'漏打卡') 
GO
INSERT INTO HtmlLabelInfo VALUES(32649,'漏打卡',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32649,'Drain punch',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32649,'漏打卡',9) 
GO