delete from HtmlLabelIndex where id in (17802,20430,20431,20432,20433,20434,20435,20436,20437,20438,20439,20440,20441,20442,20443)
go
delete from HtmlLabelInfo where indexid in (17802,20430,20431,20432,20433,20434,20435,20436,20437,20438,20439,20440,20441,20442,20443)
go


INSERT INTO HtmlLabelIndex values(17802,'项目负责人') 
GO
INSERT INTO HtmlLabelInfo VALUES(17802,'项目负责人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17802,'Project Manager',8) 
GO
INSERT INTO HtmlLabelIndex values(20430,'项目负责部门') 
GO
INSERT INTO HtmlLabelInfo VALUES(20430,'项目负责部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20430,'Project Department',8) 
GO
INSERT INTO HtmlLabelIndex values(20431,'项目起始时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(20431,'项目起始时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20431,'Start Date',8) 
GO
INSERT INTO HtmlLabelIndex values(20432,'项目结题时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(20432,'项目结题时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20432,'End Date',8) 
GO
INSERT INTO HtmlLabelIndex values(20433,'项目经费预算(万元)') 
GO
INSERT INTO HtmlLabelInfo VALUES(20433,'项目经费预算(万元)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20433,'Project Budget',8) 
GO
INSERT INTO HtmlLabelIndex values(20434,'项目变更情况') 
GO
INSERT INTO HtmlLabelInfo VALUES(20434,'项目变更情况',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20434,'Modification',8) 
GO
INSERT INTO HtmlLabelIndex values(20435,'项目产生效益') 
GO
INSERT INTO HtmlLabelInfo VALUES(20435,'项目产生效益',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20435,'Benefit',8) 
GO
INSERT INTO HtmlLabelIndex values(20436,'项目决算情况') 
GO
INSERT INTO HtmlLabelInfo VALUES(20436,'项目决算情况',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20436,'Final Accounts',8) 
GO
INSERT INTO HtmlLabelIndex values(20437,'外协单位名称') 
GO
INSERT INTO HtmlLabelInfo VALUES(20437,'外协单位名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20437,'Assist Company',8) 
GO

INSERT INTO HtmlLabelIndex values(20438,'外协合同名称') 
GO
INSERT INTO HtmlLabelIndex values(20439,'外协合同费用') 
GO
INSERT INTO HtmlLabelIndex values(20441,'外协合同结束时间') 
GO
INSERT INTO HtmlLabelIndex values(20442,'项目奖励情况') 
GO
INSERT INTO HtmlLabelIndex values(20443,'备注') 
GO
INSERT INTO HtmlLabelIndex values(20440,'外协合同起始时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(20438,'外协合同名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20438,'Bargain Name',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20439,'外协合同费用',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20439,'Bargain Fee',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20440,'外协合同起始时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20440,'Bargain Start Date',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20441,'外协合同结束时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20441,'Bargain End Date',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20442,'项目奖励情况',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20442,'Project Encouragement',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20443,'备注',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20443,'Project Memo',8) 
GO