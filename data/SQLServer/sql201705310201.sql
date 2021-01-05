delete from HtmlLabelIndex where id=130685 
GO
delete from HtmlLabelInfo where indexid=130685 
GO
INSERT INTO HtmlLabelIndex values(130685,'仅执行一次') 
GO
INSERT INTO HtmlLabelInfo VALUES(130685,'仅执行一次',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130685,'Execute only once',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130685,'僅執行壹次',9) 
GO