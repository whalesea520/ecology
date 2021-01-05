
INSERT INTO HtmlLabelIndex values(18877,'当前流程还没保存，如果离开，将会丢失数据，真的要离开吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(18877,'当前流程还没保存，如果离开，将会丢失数据，真的要离开吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18877,'This request is not saved.If leave,you will lose data,sure to leave now?',8) 
GO


delete from HtmlLabelIndex where id=18674
GO
delete from HtmlLabelInfo where indexid=18674
GO
INSERT INTO HtmlLabelIndex values(18674,'新建流程还没保存，如果离开，将会丢失数据，真的要离开吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(18674,'新建流程还没保存，如果离开，将会丢失数据，真的要离开吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18674,'New request is not saved.If leave,you will lose data,sure to leave now?',8) 
GO
