delete from HtmlLabelIndex where id=127168 
GO
delete from HtmlLabelInfo where indexid=127168 
GO
INSERT INTO HtmlLabelIndex values(127168,'系统中存在名称为：$name$的科目共有两个，导入失败！') 
GO
INSERT INTO HtmlLabelInfo VALUES(127168,'系统中存在名称为：$name$的科目共有两个，导入失败！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127168,'系统中存在名称为：$name$的科目共有两个，导入失败！',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127168,'系統中存在名稱爲：$name$的科目共有兩個，導入失敗！',9) 
GO