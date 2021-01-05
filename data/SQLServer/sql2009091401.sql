delete from HtmlLabelIndex where id=23693 
GO
delete from HtmlLabelInfo where indexid=23693 
GO
INSERT INTO HtmlLabelIndex values(23693,'已订阅') 
GO
delete from HtmlLabelIndex where id=23694 
GO
delete from HtmlLabelInfo where indexid=23694 
GO
INSERT INTO HtmlLabelIndex values(23694,'订阅待审批') 
GO
INSERT INTO HtmlLabelInfo VALUES(23693,'已订阅',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23693,'Subscribed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23693,'已訂閱',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(23694,'订阅待审批',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23694,'Subscribe to the pending',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23694,'訂閱待審批',9) 
GO
