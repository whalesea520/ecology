delete from HtmlLabelIndex where id=128911 
GO
delete from HtmlLabelInfo where indexid=128911 
GO
INSERT INTO HtmlLabelIndex values(128911,'批量提交成功，有部分流程被锁定不能提交！') 
GO
delete from HtmlLabelIndex where id=128912 
GO
delete from HtmlLabelInfo where indexid=128912 
GO
INSERT INTO HtmlLabelIndex values(128912,'所选流程被锁定，不能提交！') 
GO
INSERT INTO HtmlLabelInfo VALUES(128912,'所选流程被锁定，不能提交！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128912,'The selected process is locked and cannot be submitted!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128912,'所選流程被鎖定，不能提交！',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128911,'批量提交成功，有部分流程被锁定不能提交！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128911,'Batch submitted successfully, there are part of the process is locked can not be submitted!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128911,'批量提交成功，有部分流程被鎖定不能提交！',9) 
GO
delete from HtmlLabelIndex where id=128922 
GO
delete from HtmlLabelInfo where indexid=128922 
GO
INSERT INTO HtmlLabelIndex values(128922,'当前页面已经失效，请重新打开流程处理！') 
GO
INSERT INTO HtmlLabelInfo VALUES(128922,'当前页面已经失效，请重新打开流程处理！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128922,'The current page is not valid. Please reopen to process!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128922,'當前頁面已經失效，請重新打開流程處理！',9) 
GO