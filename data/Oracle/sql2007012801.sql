delete from HtmlLabelIndex where id in (20205,20206,20207)
/
delete from HtmlLabelInfo where indexid in (20205,20206,20207)
/

INSERT INTO HtmlLabelIndex values(20205,'上一张') 
/
INSERT INTO HtmlLabelIndex values(20206,'下一张') 
/
INSERT INTO HtmlLabelInfo VALUES(20205,'上一张',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20205,'previous',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20206,'下一张',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20206,'next',8) 
/
INSERT INTO HtmlLabelIndex values(20207,'相册管理') 
/
INSERT INTO HtmlLabelInfo VALUES(20207,'相册管理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20207,'Album Maint',8) 
/