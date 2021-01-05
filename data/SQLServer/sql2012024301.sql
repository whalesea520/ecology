delete from HtmlLabelIndex where id=27783 
GO
delete from HtmlLabelInfo where indexid=27783 
GO
INSERT INTO HtmlLabelIndex values(27783,'行规则有误，请重新设置！') 
GO
INSERT INTO HtmlLabelInfo VALUES(27783,'行规则有误，请重新设置！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27783,'Rule is error, please check it again!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27783,'行規則有誤，請重新設置！',9) 
GO
