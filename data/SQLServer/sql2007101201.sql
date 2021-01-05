delete from HtmlLabelIndex where id=20068 
GO
delete from HtmlLabelInfo where indexid=20068 
GO
INSERT INTO HtmlLabelIndex values(20068,'身份证号码重复！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20068,'身份证号码重复！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20068,'The ID card number is repeated!',8) 
GO

delete from HtmlLabelIndex where id=20945 
GO
delete from HtmlLabelInfo where indexid=20945 
GO
INSERT INTO HtmlLabelIndex values(20945,'职位名称') 
GO
INSERT INTO HtmlLabelInfo VALUES(20945,'职位名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20945,'JobNames',8) 
GO


delete from HtmlLabelIndex where id=20953 
GO
delete from HtmlLabelInfo where indexid=20953 
GO
INSERT INTO HtmlLabelIndex values(20953,'此人已经存在,是否继续？') 
GO
INSERT INTO HtmlLabelInfo VALUES(20953,'此人已经存在,是否继续？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20953,'SurewetherGo',8) 
GO