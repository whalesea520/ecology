DELETE FROM HtmlLabelIndex WHERE id = 20392
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20392
/
INSERT INTO HtmlLabelIndex values(20392,'自定义会议地点') 
/
INSERT INTO HtmlLabelInfo VALUES(20392,'自定义会议地点',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20392,'Customize Meeting Address',8) 
/

DELETE FROM HtmlLabelIndex WHERE id = 20393
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20393
/
INSERT INTO HtmlLabelIndex values(20393,'请选择会议地点或者自定义会议地点！') 
/
INSERT INTO HtmlLabelInfo VALUES(20393,'请选择会议地点或者自定义会议地点！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20393,'It is necessary to input the meeting address or customize meeting address!',8) 
/
