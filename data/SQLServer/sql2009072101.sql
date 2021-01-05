delete from HtmlLabelIndex where id=23548 
GO
delete from HtmlLabelInfo where indexid=23548 
GO
INSERT INTO HtmlLabelIndex values(23548,'不能小于已存在数据的长度') 
GO
INSERT INTO HtmlLabelInfo VALUES(23548,'不能小于已存在数据的长度！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23548,'Can not be less than the length of the data already exists!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23548,'不能小於已存在數據的長度！',9) 
GO