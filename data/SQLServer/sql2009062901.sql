delete from HtmlLabelIndex where id=23222 
GO
delete from HtmlLabelInfo where indexid=23222 
GO
INSERT INTO HtmlLabelIndex values(23222,'失去焦点') 
GO
delete from HtmlLabelIndex where id=23221 
GO
delete from HtmlLabelInfo where indexid=23221 
GO
INSERT INTO HtmlLabelIndex values(23221,'获得焦点') 
GO
INSERT INTO HtmlLabelInfo VALUES(23221,'获得焦点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23221,'Get Focus',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23221,'獲得焦點',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(23222,'失去焦点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23222,'Lose Focus',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23222,'失去焦點',9) 
GO
