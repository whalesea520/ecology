delete from HtmlLabelIndex where id=20537
go
delete from HtmlLabelInfo where indexid=20537
go

INSERT INTO HtmlLabelIndex values(20537,'确定删除选定的信息及包含内容吗') 
GO
INSERT INTO HtmlLabelInfo VALUES(20537,'确定删除选定的信息及包含内容吗',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20537,'Are you sure you want to delete it',8) 
GO