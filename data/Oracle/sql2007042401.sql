DELETE FROM HtmlLabelIndex WHERE id = 20312
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20312
/

INSERT INTO HtmlLabelIndex values(20312,'持续时间应该大于0！') 
/
INSERT INTO HtmlLabelInfo VALUES(20312,'持续时间应该大于0！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20312,'Persistent Time should be more than 0!',8) 
/