delete from HtmlLabelIndex where id=22603 
GO
delete from HtmlLabelInfo where indexid=22603 
GO
INSERT INTO HtmlLabelIndex values(22603,'文件存放目录与文件备份目录不能一致！') 
GO
INSERT INTO HtmlLabelInfo VALUES(22603,'文件存放目录与文件备份目录不能一致！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22603,'File Save Catalog and File Backup Catalog should not consistent!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22603,'檔存放目錄與檔備份目錄不能一致！',9) 
GO