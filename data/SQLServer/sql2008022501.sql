delete from HtmlLabelIndex where id=21266 
GO
delete from HtmlLabelInfo where indexid=21266 
GO
INSERT INTO HtmlLabelIndex values(21266,'处理前流程已经流转到了下一节点') 
GO
INSERT INTO HtmlLabelInfo VALUES(21266,'处理前流程已经流转到了下一节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21266,'Circulation has been dealt with before the process to the next node',8) 
GO
delete from HtmlLabelIndex where id=21270 
GO
delete from HtmlLabelInfo where indexid=21270 
GO
INSERT INTO HtmlLabelIndex values(21270,'流程流转超时，请重试') 
GO
INSERT INTO HtmlLabelInfo VALUES(21270,'流程流转超时，请重试',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21270,'Overtime transfer process, please try again',8) 
GO