delete from HtmlLabelIndex where id=130084 
GO
delete from HtmlLabelInfo where indexid=130084 
GO
INSERT INTO HtmlLabelIndex values(130084,'退回时签字意见必填') 
GO
INSERT INTO HtmlLabelInfo VALUES(130084,'退回时签字意见必填',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130084,'return signed opinions required',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130084,'退回時簽字意見必填',9) 
GO

delete from HtmlLabelIndex where id=130085 
GO
delete from HtmlLabelInfo where indexid=130085 
GO
INSERT INTO HtmlLabelIndex values(130085,'签字意见默认是前一节点最后一个操作者意见') 
GO
INSERT INTO HtmlLabelInfo VALUES(130085,'签字意见默认是前一节点最后一个操作者意见',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130085,'The default view is the last operator of the previous node',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130085,'簽字意見默認是前一節點最後一個操作者意見',9) 
GO