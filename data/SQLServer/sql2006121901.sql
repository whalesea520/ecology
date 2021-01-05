delete from HtmlLabelIndex where id in (20040,20041)
go
delete from HtmlLabelInfo where indexid in (20040,20041)
go
INSERT INTO HtmlLabelIndex values(20040,'Excel文件导入失败，请检查Excel文件格式是否正确！') 
go
INSERT INTO HtmlLabelIndex values(20041,'文件不存在!') 
go
INSERT INTO HtmlLabelInfo VALUES(20040,'Excel文件导入失败，请检查Excel文件格式是否正确！',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20040,'Excel File Imported Error,Please Check File!',8) 
go
INSERT INTO HtmlLabelInfo VALUES(20041,'文件不存在!',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20041,'File is not existed!',8) 
go
