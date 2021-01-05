delete from HtmlLabelIndex where id=22208 
GO
delete from HtmlLabelInfo where indexid=22208 
GO
INSERT INTO HtmlLabelIndex values(22208,'放大') 
GO
delete from HtmlLabelIndex where id=22209 
GO
delete from HtmlLabelInfo where indexid=22209 
GO
INSERT INTO HtmlLabelIndex values(22209,'缩小') 
GO
INSERT INTO HtmlLabelInfo VALUES(22208,'放大',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22208,'to blow up',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22208,'',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22209,'缩小',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22209,'to reduce',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22209,'',9) 
GO
