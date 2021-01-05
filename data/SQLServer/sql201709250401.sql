delete from HtmlLabelIndex where id=130805 
GO
delete from HtmlLabelInfo where indexid=130805 
GO
INSERT INTO HtmlLabelIndex values(130805,'新建记录时主键不允许赋值！') 
GO
INSERT INTO HtmlLabelInfo VALUES(130805,'新建记录时主键不允许赋值！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130805,'Primary key does not allow assignment when new record is created!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130805,'新建記錄時主鍵不允許賦值！',9) 
GO

delete from HtmlLabelIndex where id=130806 
GO
delete from HtmlLabelInfo where indexid=130806 
GO
INSERT INTO HtmlLabelIndex values(130806,'更新记录时主键不能为空！') 
GO
INSERT INTO HtmlLabelInfo VALUES(130806,'更新记录时主键不能为空！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130806,'The primary key cannot be empty when updating records!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130806,'更新記錄時主鍵不能爲空！',9) 
GO