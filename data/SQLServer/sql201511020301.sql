
delete from HtmlLabelIndex where id=126007 
GO
delete from HtmlLabelInfo where indexid=126007 
GO
INSERT INTO HtmlLabelIndex values(126007,'本次共操作{param}条数据，') 
GO
INSERT INTO HtmlLabelInfo VALUES(126007,'本次共操作{param}条数据，',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126007,'The total operating {param} data,',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126007,'本次共操作{param}條數據，',9) 
GO
delete from HtmlLabelIndex where id=126009 
GO
delete from HtmlLabelInfo where indexid=126009 
GO
INSERT INTO HtmlLabelIndex values(126009,'{param}条无删除权限。') 
GO
INSERT INTO HtmlLabelInfo VALUES(126009,'{param}条无删除权限。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126009,'{param} no delete privileges.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126009,'{param}條無刪除權限。',9) 
GO
delete from HtmlLabelIndex where id=126011 
GO
delete from HtmlLabelInfo where indexid=126011 
GO
INSERT INTO HtmlLabelIndex values(126011,'{param}条删除成功。') 
GO
INSERT INTO HtmlLabelInfo VALUES(126011,'{param}条删除成功。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126011,'{param} deleted successfully.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126011,'{param}條刪除成功。',9) 
GO
delete from HtmlLabelIndex where id=126010 
GO
delete from HtmlLabelInfo where indexid=126010 
GO
INSERT INTO HtmlLabelIndex values(126010,'{param}条删除成功，') 
GO
INSERT INTO HtmlLabelInfo VALUES(126010,'{param}条删除成功，',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126010,'{param} deleted successfully,',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126010,'{param}條刪除成功，',9) 
GO
