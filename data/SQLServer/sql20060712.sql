CREATE TABLE [Workflow_SubwfSet] (
	[id] [int]  NOT NULL ,
        [mainWorkflowId] int NULL , 
        [subWorkflowId] int NULL ,
        [triggerNodeId] int NULL ,
        [triggerTime] [char] (1) NULL ,
        [subwfCreatorType] [char] (1) NULL ,
        [subwfCreatorFieldId] int NULL 
) 
GO

CREATE TABLE [Workflow_SubwfSetDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
        [subwfSetId] int NULL , 
        [subWorkflowFieldId] int NULL ,
        [mainWorkflowFieldId] int NULL ,
        [ifSplitField] char(1) NULL 
) 
GO

ALTER TABLE workflow_requestbase ADD mainRequestId INT NULL
GO

delete from  SequenceIndex where indexdesc='Workflow_SubwfSetId'
GO

insert into SequenceIndex(indexdesc,currentid) values('Workflow_SubwfSetId',1)
GO


INSERT INTO HtmlLabelIndex values(19347,'触发时间') 
GO
INSERT INTO HtmlLabelIndex values(19348,'到达节点') 
GO
INSERT INTO HtmlLabelIndex values(19352,'子流程创建人') 
GO
INSERT INTO HtmlLabelIndex values(19353,'主流程当前操作人') 
GO
INSERT INTO HtmlLabelIndex values(19349,'离开节点') 
GO
INSERT INTO HtmlLabelIndex values(19350,'子流程列表') 
GO
INSERT INTO HtmlLabelIndex values(19351,'子流程名称') 
GO
INSERT INTO HtmlLabelIndex values(19354,'主流程创建人') 
GO
INSERT INTO HtmlLabelIndex values(19355,'主流程单人力资源字段') 
GO
INSERT INTO HtmlLabelIndex values(19357,'子流程字段') 
GO
INSERT INTO HtmlLabelIndex values(19358,'主流程字段') 
GO
INSERT INTO HtmlLabelIndex values(19359,'字段值拆分') 
GO
INSERT INTO HtmlLabelIndex values(19361,'每人力资源创建单独子流程') 
GO
INSERT INTO HtmlLabelIndex values(19362,'主流程查询') 
GO
INSERT INTO HtmlLabelIndex values(19363,'子流程状况') 
GO
INSERT INTO HtmlLabelIndex values(19343,'数据出口') 
GO
INSERT INTO HtmlLabelIndex values(19345,'添加子流程') 
GO
INSERT INTO HtmlLabelIndex values(19356,'子流程数据导入') 
GO
INSERT INTO HtmlLabelIndex values(19346,'触发节点') 
GO
INSERT INTO HtmlLabelIndex values(19344,'子流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(19343,'数据出口',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19343,'Data Exit',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19344,'子流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19344,'SubWorkflow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19345,'添加子流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19345,'Add SubWorkflow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19346,'触发节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19346,'Trigger Node',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19347,'触发时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19347,'Trigger Time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19348,'到达节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19348,'Reach Node',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19349,'离开节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19349,'Leave Node',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19350,'子流程列表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19350,'SubWorkflow List',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19351,'子流程名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19351,'SubWorkflow Name',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19352,'子流程创建人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19352,'SubWorkflow Creator',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19353,'主流程当前操作人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19353,'MainWorkflow CurrentOperator',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19354,'主流程创建人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19354,'MainWorkflow Creator',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19355,'主流程单人力资源字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19355,'MainWorkflow Single HR Field',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19356,'子流程数据导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19356,'SubWorkflow Data Import',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19357,'子流程字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19357,'SubWorkflow Field',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19358,'主流程字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19358,'MainWorkflow Field',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19359,'字段值拆分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19359,'Field Value Split',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19361,'每人力资源创建单独子流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19361,'New Single SubWorkflow For Per HR',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19362,'主流程查询',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19362,'MainWorkflow Search',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19363,'子流程状况',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19363,'SubWorkflow Status',8) 
GO


update HtmlLabelIndex set indexdesc='主流程人力资源相关字段'  where id=19355
GO
update HtmlLabelInfo set labelname='主流程人力资源相关字段' where indexid=19355 and languageid=7
GO
update HtmlLabelInfo set labelname='MainWorkflow HR Related Field' where indexid=19355 and languageid=8
GO

INSERT INTO HtmlLabelIndex values(19455,'子流程创建人无值，请检查子流程创建人设置。') 
GO
INSERT INTO HtmlLabelInfo VALUES(19455,'子流程创建人无值，请检查子流程创建人设置。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19455,'The subWorkflow creator is null,check the setting of the subWorkflow creator please.',8) 
GO
