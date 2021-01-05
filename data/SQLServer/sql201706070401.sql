delete from HtmlLabelIndex where id=130729 
GO
delete from HtmlLabelInfo where indexid=130729 
GO
INSERT INTO HtmlLabelIndex values(130729,'以下表单存在重复') 
GO
INSERT INTO HtmlLabelInfo VALUES(130729,'以下表单存在重复',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130729,'The following form is duplicated',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130729,'以下表單存在重複',9) 
GO