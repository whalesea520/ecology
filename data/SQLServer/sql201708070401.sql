delete from HtmlLabelIndex where id=130809 
GO
delete from HtmlLabelInfo where indexid=130809 
GO
INSERT INTO HtmlLabelIndex values(130809,'安全级别不能保存为负数') 
GO
INSERT INTO HtmlLabelInfo VALUES(130809,'安全级别不能保存为负数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130809,'security level cannot be saved as negative',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130809,'安全級别不能保存爲負數',9) 
GO