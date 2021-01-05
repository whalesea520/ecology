delete from HtmlLabelIndex where id=130952 
GO
delete from HtmlLabelInfo where indexid=130952 
GO
INSERT INTO HtmlLabelIndex values(130952,'【短信已经发送，请1分钟后重试】') 
GO
INSERT INTO HtmlLabelInfo VALUES(130952,'【短信已经发送，请1分钟后重试】',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130952,'【message has been sent,please retry after 1 mins】',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130952,'【短信已經發送，請1分鍾後重試】',9) 
GO