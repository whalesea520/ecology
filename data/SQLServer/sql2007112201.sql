delete from HtmlLabelIndex where id=21128 
GO
delete from HtmlLabelInfo where indexid=21128 
GO
INSERT INTO HtmlLabelIndex values(21128,'车辆保险到期提醒设置') 
GO
delete from HtmlLabelIndex where id=21129 
GO
delete from HtmlLabelInfo where indexid=21129 
GO
INSERT INTO HtmlLabelIndex values(21129,'车辆年检到期提醒设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(21128,'车辆保险到期提醒设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21128,'Due to remind set up vehicle insurance',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21129,'车辆年检到期提醒设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21129,'Due to remind set the annual inspection of vehicles',8) 
GO
delete from HtmlLabelIndex where id=21124 
GO
delete from HtmlLabelInfo where indexid=21124 
GO
INSERT INTO HtmlLabelIndex values(21124,'车辆提醒设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(21124,'车辆提醒设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21124,'Vehicles reminded set',8) 
GO