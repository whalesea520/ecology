delete from HtmlLabelIndex where id=21004 
/
delete from HtmlLabelInfo where indexid=21004 
/
INSERT INTO HtmlLabelIndex values(21004,'是否自动刷屏') 
/
INSERT INTO HtmlLabelInfo VALUES(21004,'是否自动刷屏',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21004,'isAutoRefresh',8) 
/

delete from HtmlLabelIndex where id=21005 
/
delete from HtmlLabelInfo where indexid=21005 
/
INSERT INTO HtmlLabelIndex values(21005,'自动刷屏间隔时间(分钟)') 
/
INSERT INTO HtmlLabelInfo VALUES(21005,'自动刷屏间隔时间(分钟)',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21005,'MinsOfRefresh',8) 
/

