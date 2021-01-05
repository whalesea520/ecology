delete from HtmlLabelIndex where id=23984 
GO
delete from HtmlLabelInfo where indexid=23984 
GO
INSERT INTO HtmlLabelIndex values(23984,'文件名称不能包含中文') 
GO
INSERT INTO HtmlLabelInfo VALUES(23984,'文件名称不能包含中文',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23984,'File name can''t have Chinese char',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23984,'文件名稱不能包含中文',9) 
GO

delete from HtmlLabelIndex where id=23999 
GO
delete from HtmlLabelInfo where indexid=23999 
GO
INSERT INTO HtmlLabelIndex values(23999,'默认数据源') 
GO
INSERT INTO HtmlLabelInfo VALUES(23999,'默认数据源',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23999,'Default DataSource',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23999,'默認數據源',9) 
GO
