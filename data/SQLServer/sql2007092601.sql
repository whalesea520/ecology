delete from HtmlLabelIndex where id=20902 
GO
delete from HtmlLabelInfo where indexid=20902 
GO
INSERT INTO HtmlLabelIndex values(20902,'报销金额超出预算') 
GO
INSERT INTO HtmlLabelInfo VALUES(20902,'报销金额超出预算!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20902,'apply sum outsite the budget!',8) 
GO
 
delete from HtmlLabelIndex where id=20897 
GO
delete from HtmlLabelInfo where indexid=20897 
GO
INSERT INTO HtmlLabelIndex values(20897,'所耗时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(20897,'所耗时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20897,'spend time',8) 
GO