delete from HtmlLabelIndex where id=128727 
GO
delete from HtmlLabelInfo where indexid=128727 
GO
INSERT INTO HtmlLabelIndex values(128727,'当前数据被锁定，请稍后再试！') 
GO
INSERT INTO HtmlLabelInfo VALUES(128727,'当前数据被锁定，请稍后再试！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128727,'The current data is locked. Please try again later!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128727,'當前數據被鎖定，請稍後再試！',9) 
GO