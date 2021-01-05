delete from HtmlLabelIndex where id=23595 
GO
delete from HtmlLabelInfo where indexid=23595 
GO
INSERT INTO HtmlLabelIndex values(23595,'流程操作失败，本次操作未能与EAS系统数据成功连接') 
GO
INSERT INTO HtmlLabelInfo VALUES(23595,'流程操作失败，本次操作未能与EAS系统数据成功连接',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23595,'can''t connect to EAS,workflow failed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23595,'流程操作失敗，本次操作未能與EAS系統數據成功連接',9) 
GO
