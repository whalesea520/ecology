INSERT INTO HtmlLabelIndex values(18812,'流程计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(18812,'流程计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18812,'flow plan',8) 
GO


insert into SystemRights (id,rightdesc,righttype) values (642,'流程计划设置','5') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (642,7,'流程计划设置','流程计划设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (642,8,'flow plan set','flow plan set') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4142,'流程计划设置','WorkFlowPlanSet:All',642) 
GO



CREATE TABLE WorkFlowPlanSet(
	id int IDENTITY(1,1) NOT NULL,
	status char(1)  NULL,
	frequencyt char(1)  NULL,
	dateType char(1)  NULL,
	dateSum int NULL,
	timeSet varchar(8) NULL,
	alertType char(1)  NULL,
	flowId int NULL
) 
Go


CREATE TABLE WorkFlowPlanDetail(
	id int IDENTITY(1,1) NOT NULL,
	userId int  NULL,
	autoType char(1)  NULL,
	flowDate varchar(6)  NULL,
	flowId int NULL
) 
Go

INSERT INTO HtmlLabelIndex values(18813,'频率') 
GO
INSERT INTO HtmlLabelInfo VALUES(18813,'频率',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18813,'frequency',8) 
GO

INSERT INTO HtmlLabelIndex values(18814,'日期设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(18814,'日期设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18814,'set date',8) 
GO

INSERT INTO HtmlLabelIndex values(18815,'点') 
GO
INSERT INTO HtmlLabelInfo VALUES(18815,'点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18815,'point',8) 
GO
 
INSERT INTO HtmlLabelIndex values(18816,'倒数') 
GO
INSERT INTO HtmlLabelIndex values(18817,'正数') 
GO
INSERT INTO HtmlLabelInfo VALUES(18816,'倒数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18816,'down list',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18817,'正数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18817,'up list',8) 
GO

INSERT INTO HtmlLabelIndex values(18819,'日期设置不合理') 
GO
INSERT INTO HtmlLabelInfo VALUES(18819,'日期设置不合理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18819,'date set not availability',8) 
GO
