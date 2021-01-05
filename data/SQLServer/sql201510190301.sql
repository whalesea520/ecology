delete from HtmlLabelIndex where id=22214 
GO
delete from HtmlLabelInfo where indexid=22214 
GO
INSERT INTO HtmlLabelIndex values(22214,'所选上级分部不能为当前分部本身！') 
GO
INSERT INTO HtmlLabelInfo VALUES(22214,'所选上级分部不能为当前分部本身！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22214,'Higher levels can not be selected for the current division branch itself!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22214,'所選上級分部不能為當前分部本身！',9) 
GO