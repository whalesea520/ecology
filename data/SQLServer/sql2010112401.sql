delete from HtmlLabelIndex where id=25354 
GO
delete from HtmlLabelInfo where indexid=25354 
GO
INSERT INTO HtmlLabelIndex values(25354,'未调查客户列表') 
GO
delete from HtmlLabelIndex where id=25353 
GO
delete from HtmlLabelInfo where indexid=25353 
GO
INSERT INTO HtmlLabelIndex values(25353,'已调查客户列表') 
GO
INSERT INTO HtmlLabelInfo VALUES(25353,'已调查客户列表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(25353,'InvestigatedCustomerList',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(25353,'已調查客戶列表',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(25354,'未调查客户列表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(25354,'NotinvestigatedCustomerList',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(25354,'為調查客戶列表',9) 
GO
