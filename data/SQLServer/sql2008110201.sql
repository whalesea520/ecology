delete from HtmlLabelIndex where id=21987 
GO
delete from HtmlLabelInfo where indexid=21987 
GO
INSERT INTO HtmlLabelIndex values(21987,'退回到该节点') 
GO
delete from HtmlLabelIndex where id=21988 
GO
delete from HtmlLabelInfo where indexid=21988 
GO
INSERT INTO HtmlLabelIndex values(21988,'触发') 
GO
delete from HtmlLabelIndex where id=21989 
GO
delete from HtmlLabelInfo where indexid=21989 
GO
INSERT INTO HtmlLabelIndex values(21989,'不触发') 
GO
INSERT INTO HtmlLabelInfo VALUES(21987,'退回到该节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21987,'draw back to this node',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21987,'退回到該節點',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(21988,'触发',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21988,'touch off',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21988,'觸發',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(21989,'不触发',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21989,'do not touch off',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21989,'不觸發',9) 
GO
delete from HtmlLabelIndex where id=21987 
GO
delete from HtmlLabelInfo where indexid=21987 
GO
INSERT INTO HtmlLabelIndex values(21987,'退回时是否触发此操作') 
GO
INSERT INTO HtmlLabelInfo VALUES(21987,'退回时是否触发此操作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21987,'draw back to this node',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21987,'退回時是否觸發此操作',9) 
GO