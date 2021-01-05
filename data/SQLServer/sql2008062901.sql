delete from HtmlLabelIndex where id=21603 
GO
delete from HtmlLabelInfo where indexid=21603 
GO
INSERT INTO HtmlLabelIndex values(21603,'审批意见排序') 
GO
delete from HtmlLabelIndex where id=21604 
GO
delete from HtmlLabelInfo where indexid=21604 
GO
INSERT INTO HtmlLabelIndex values(21604,'倒序') 
GO
delete from HtmlLabelIndex where id=21605 
GO
delete from HtmlLabelInfo where indexid=21605 
GO
INSERT INTO HtmlLabelIndex values(21605,'正序') 
GO
INSERT INTO HtmlLabelInfo VALUES(21603,'审批意见排序',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21603,'Approvement Opinion Order',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21604,'倒序',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21604,'Reverse Order',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21605,'正序',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21605,'Obverse Order',8) 
GO


delete from HtmlLabelIndex where id=21629 
GO
delete from HtmlLabelInfo where indexid=21629 
GO
INSERT INTO HtmlLabelIndex values(21629,'按提交意见的时间由后到前排列') 
GO
delete from HtmlLabelIndex where id=21628 
GO
delete from HtmlLabelInfo where indexid=21628 
GO
INSERT INTO HtmlLabelIndex values(21628,'按提交意见的时间由前到后排列') 
GO
INSERT INTO HtmlLabelInfo VALUES(21628,'按提交意见的时间由前到后排列',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21628,'dispaly from top to botton order by time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21629,'按提交意见的时间由后到前排列',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21629,'dispaly from botton to top order by time',8) 
GO
