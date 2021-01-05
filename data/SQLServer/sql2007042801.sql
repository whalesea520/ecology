delete from HtmlLabelIndex where id in(20308,20309,20310,20311,20313,20314,20315)
GO
delete from HtmlLabelInfo where indexid in(20308,20309,20310,20311,20313,20314,20315)
GO
INSERT INTO HtmlLabelIndex values(20308,'基础连接数') 
GO
INSERT INTO HtmlLabelInfo VALUES(20308,'基础连接数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20308,'Base Links',8) 
GO
INSERT INTO HtmlLabelIndex values(20309,'增加连接数') 
GO
INSERT INTO HtmlLabelInfo VALUES(20309,'增加连接数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20309,'Add License Num',8) 
GO
INSERT INTO HtmlLabelIndex values(20310,'每连接单价') 
GO
INSERT INTO HtmlLabelInfo VALUES(20310,'每连接单价',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20310,'License Price',8) 
GO
INSERT INTO HtmlLabelIndex values(20311,'总连接数') 
GO
INSERT INTO HtmlLabelInfo VALUES(20311,'总连接数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20311,'License Num',8) 
GO
INSERT INTO HtmlLabelIndex values(20313,'标准价格') 
GO
INSERT INTO HtmlLabelInfo VALUES(20313,'标准价格',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20313,'Marked Price',8) 
GO
INSERT INTO HtmlLabelIndex values(20314,'其他费用') 
GO
INSERT INTO HtmlLabelInfo VALUES(20314,'其他费用',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20314,'Other Fee',8) 
GO
INSERT INTO HtmlLabelIndex values(20315,'最终总价') 
GO
INSERT INTO HtmlLabelInfo VALUES(20315,'最终总价',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20315,'Last Sum',8) 
GO



