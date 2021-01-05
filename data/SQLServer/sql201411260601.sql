delete from HtmlLabelIndex where id=32369 
GO
delete from HtmlLabelInfo where indexid=32369 
GO
INSERT INTO HtmlLabelIndex values(32369,'回写标志到外部主表') 
GO
INSERT INTO HtmlLabelInfo VALUES(32369,'回写标志到外部主表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32369,'write-back to an external master table flag',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32369,'回寫标志到外部主表',9) 
GO