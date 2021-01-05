alter table MailResource add flag int
/
delete from HtmlLabelIndex where id=125055 
/
delete from HtmlLabelInfo where indexid=125055 
/
INSERT INTO HtmlLabelIndex values(125055,'已转发') 
/
INSERT INTO HtmlLabelInfo VALUES(125055,'已转发',7) 
/
INSERT INTO HtmlLabelInfo VALUES(125055,'forwarded',8) 
/
INSERT INTO HtmlLabelInfo VALUES(125055,'已轉發',9) 
/
delete from HtmlLabelIndex where id=125056 
/
delete from HtmlLabelInfo where indexid=125056 
/
INSERT INTO HtmlLabelIndex values(125056,'已回复') 
/
INSERT INTO HtmlLabelInfo VALUES(125056,'已回复',7) 
/
INSERT INTO HtmlLabelInfo VALUES(125056,'replied',8) 
/
INSERT INTO HtmlLabelInfo VALUES(125056,'已回複',9) 
/
delete from HtmlLabelIndex where id=125057 
/
delete from HtmlLabelInfo where indexid=125057 
/
INSERT INTO HtmlLabelIndex values(125057,'已转发且已回复') 
/
INSERT INTO HtmlLabelInfo VALUES(125057,'已转发且已回复',7) 
/
INSERT INTO HtmlLabelInfo VALUES(125057,'Have forwarded and reply',8) 
/
INSERT INTO HtmlLabelInfo VALUES(125057,'已轉發且已回複',9) 
/
delete from HtmlLabelIndex where id=24714 
/
delete from HtmlLabelInfo where indexid=24714 
/
INSERT INTO HtmlLabelIndex values(24714,'内部邮件') 
/
INSERT INTO HtmlLabelInfo VALUES(24714,'内部邮件',7) 
/
INSERT INTO HtmlLabelInfo VALUES(24714,'Inner Email',8) 
/
INSERT INTO HtmlLabelInfo VALUES(24714,'內部郵件',9) 
/