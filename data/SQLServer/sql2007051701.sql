delete from HtmlLabelIndex where id=20395
GO
delete from HtmlLabelInfo where indexId=20395
GO
INSERT INTO HtmlLabelIndex values(20395,'请填写退回原因！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20395,'请填写退回原因！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20395,'Please input the reason of rejection!',8) 
GO