DELETE FROM HtmlLabelIndex WHERE id = 20114
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20114
/
INSERT INTO HtmlLabelIndex values(20114,'已取消') 
/
INSERT INTO HtmlLabelInfo VALUES(20114,'已取消',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20114,'Have Been Canceled',8) 
/

DELETE FROM HtmlLabelIndex WHERE id = 20115
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20115
/
INSERT INTO HtmlLabelIndex values(20115,'取消会议') 
/
INSERT INTO HtmlLabelInfo VALUES(20115,'取消会议',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20115,'Cancel Meeting',8) 
/

DELETE FROM HtmlLabelIndex WHERE id = 20117
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20117
/
INSERT INTO HtmlLabelIndex values(20117,'你确定要取消会议吗？') 
/
INSERT INTO HtmlLabelInfo VALUES(20117,'你确定要取消会议吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20117,'Are you sure to cancel the meeting?',8) 
/