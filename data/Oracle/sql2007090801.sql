delete from HtmlLabelIndex where id=20888
/
delete from HtmlLabelInfo  where indexid=20888
/
delete from HtmlLabelIndex where id=20889
/
delete from HtmlLabelInfo  where indexid=20889
/
INSERT INTO HtmlLabelIndex values(20888,'已经设置了自定义会议地点') 
/
INSERT INTO HtmlLabelIndex values(20889,'已经选择了会议地点') 
/
INSERT INTO HtmlLabelInfo VALUES(20888,'已经设置了自定义会议地点',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20888,'Already Customize Meeting Address',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20889,'已经选择了会议地点',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20889,'Selected Meeting Address',8) 
/

UPDATE license set cversion = '4.000.0907'
/