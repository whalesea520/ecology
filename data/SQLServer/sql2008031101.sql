delete from HtmlLabelIndex where id=21384 
GO
delete from HtmlLabelInfo where indexid=21384 
GO
INSERT INTO HtmlLabelIndex values(21384,'网段策略') 
GO
INSERT INTO HtmlLabelInfo VALUES(21384,'网段策略',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21384,'NetworkSegmentStrategy',8) 
GO

delete from HtmlLabelIndex where id=21385 
GO
delete from HtmlLabelInfo where indexid=21385 
GO
INSERT INTO HtmlLabelIndex values(21385,'IP网段') 
GO
INSERT INTO HtmlLabelInfo VALUES(21385,'IP网段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21385,'IPSegment',8) 
GO

delete from HtmlLabelIndex where id=21386 
GO
delete from HtmlLabelInfo where indexid=21386 
GO
INSERT INTO HtmlLabelIndex values(21386,'网段说明') 
GO
INSERT INTO HtmlLabelInfo VALUES(21386,'网段说明',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21386,'SegmentDesc',8) 
GO

delete from HtmlLabelIndex where id=21387 
GO
delete from HtmlLabelInfo where indexid=21387 
GO
INSERT INTO HtmlLabelIndex values(21387,'起始IP地址') 
GO
INSERT INTO HtmlLabelInfo VALUES(21387,'起始IP地址',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21387,'InceptIPAddress',8) 
GO

delete from HtmlLabelIndex where id=21388 
GO
delete from HtmlLabelInfo where indexid=21388 
GO
INSERT INTO HtmlLabelIndex values(21388,'截止IP地址') 
GO
INSERT INTO HtmlLabelInfo VALUES(21388,'截止IP地址',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21388,'EndIPAddress',8) 
GO

delete from HtmlLabelIndex where id=21389 
GO
delete from HtmlLabelInfo where indexid=21389 
GO
INSERT INTO HtmlLabelIndex values(21389,'请指定一个介于1和223之间的数值') 
GO
INSERT INTO HtmlLabelInfo VALUES(21389,'请指定一个介于1和223之间的数值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21389,'Please specify a range between 1 and 223 Numerical',8) 
GO

delete from HtmlLabelIndex where id=21390 
GO
delete from HtmlLabelInfo where indexid=21390 
GO
INSERT INTO HtmlLabelIndex values(21390,'不是一个有效项目') 
GO
INSERT INTO HtmlLabelInfo VALUES(21390,'不是一个有效项目',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21390,'Is not a valid project',8) 
GO

delete from HtmlLabelIndex where id=21392 
GO
delete from HtmlLabelInfo where indexid=21392 
GO
INSERT INTO HtmlLabelIndex values(21392,'请指定一个介于0和255之间的数值') 
GO
INSERT INTO HtmlLabelInfo VALUES(21392,'请指定一个介于0和255之间的数值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21392,'Please specify a range between 0 and 255 Numerical',8) 
GO

delete from HtmlLabelIndex where id=17581 
GO
delete from HtmlLabelInfo where indexid=17581 
GO
INSERT INTO HtmlLabelIndex values(17581,'停止') 
GO
INSERT INTO HtmlLabelInfo VALUES(17581,'停止',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17581,'stop',8) 
GO

delete from SystemRights where id = 773
GO
delete from SystemRightsLanguage where id = 773
GO
delete from SystemRightDetail where id = 4283
GO
insert into SystemRights (id,rightdesc,righttype) values (773,'网段策略维护','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (773,8,'NetworkSegmentStrategy','NetworkSegmentStrategy') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (773,7,'网段策略维护','网段策略维护') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4283,'网段策略维护','NetworkSegmentStrategy:All',773) 
GO
