delete from HtmlLabelIndex where id=21416 
GO
delete from HtmlLabelInfo where indexid=21416 
GO
INSERT INTO HtmlLabelIndex values(21416,'此预算期间为已关闭期间') 
GO
INSERT INTO HtmlLabelInfo VALUES(21416,'此预算期间为已关闭期间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21416,'The budget had been closed during the period',8) 
GO

delete from HtmlLabelIndex where id=21419 
GO
delete from HtmlLabelInfo where indexid=21419 
GO
INSERT INTO HtmlLabelIndex values(21419,'确定将科目') 
GO
delete from HtmlLabelIndex where id=21420 
GO
delete from HtmlLabelInfo where indexid=21420 
GO
INSERT INTO HtmlLabelIndex values(21420,'新预算额清零?') 
GO
INSERT INTO HtmlLabelInfo VALUES(21419,'确定将科目',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21419,'Are you sure to cleared the new budget of this subject?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21420,'新预算额清零?',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21420,'',8) 
GO
