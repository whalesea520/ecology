delete from HtmlLabelIndex where id=127683 
GO
delete from HtmlLabelInfo where indexid=127683 
GO
INSERT INTO HtmlLabelIndex values(127683,'结束时间不能小于等于开始时间') 
GO
delete from HtmlLabelIndex where id=127684 
GO
delete from HtmlLabelInfo where indexid=127684 
GO
INSERT INTO HtmlLabelIndex values(127684,'设置开始时间必须设置开始日期') 
GO
delete from HtmlLabelIndex where id=127685 
GO
delete from HtmlLabelInfo where indexid=127685 
GO
INSERT INTO HtmlLabelIndex values(127685,'设置结束时间必须设置结束日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(127685,'设置结束时间必须设置结束日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127685,'Sets the end time must be set end date',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127685,'设置结束时间必须设置结束日期',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(127684,'设置开始时间必须设置开始日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127684,'Set the start time must be set start date',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127684,'设置开始时间必须设置开始日期',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(127683,'结束时间不能小于等于开始时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127683,'End time can not be less than or equal to start time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127683,'结束时间不能小于等于开始时间',9) 
GO