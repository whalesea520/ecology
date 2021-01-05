delete from HtmlLabelIndex where id =20040
/
delete from HtmlLabelIndex where id =20041
/
delete from HtmlLabelInfo where indexid=20040
/
delete from HtmlLabelInfo where indexid=20041
/
INSERT INTO HtmlLabelIndex values(20040,'Excel文件导入失败，请检查Excel文件格式是否正确！') 
/
INSERT INTO HtmlLabelIndex values(20041,'文件不存在!') 
/
INSERT INTO HtmlLabelInfo VALUES(20040,'Excel文件导入失败，请检查Excel文件格式是否正确！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20040,'Excel File Imported Error,Please Check File!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20041,'文件不存在!',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20041,'File is not existed!',8) 
/
