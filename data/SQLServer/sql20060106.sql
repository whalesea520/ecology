/*表单模板*/
CREATE TABLE workflow_formmode ( 
    id int not null IDENTITY (1,1),	/*自增长ID*/
    formid int,	/*表单id*/
    isbill varchar(1),	/*是否为单据*/
    isprint varchar(1),	/*是否打印模板*/
    modename varchar(200),/*模板名称*/
    modedesc text	/*模板内容*/
)
GO
/*节点模板*/
CREATE TABLE workflow_nodemode ( 
    id int not null IDENTITY (1,1),	/*自增长ID*/
    workflowid int,/*工作流id*/
    formid int,/*表单id*/
    nodeid int,	/*节点id*/
    isprint varchar(1),	/*是否打印模板*/
    modename varchar(200),/*模板名称*/
    modedesc text	/*模板内容*/
)
GO
/*显示类型*/
alter table workflow_flownode add ismode varchar(1)
go
/*不引用显示模板*/
alter table workflow_flownode add showdes varchar(1)
go
/*不引用打印模板*/
alter table workflow_flownode add printdes varchar(1)
go

INSERT INTO HtmlLabelIndex values(18016,'普通模式') 
GO
INSERT INTO HtmlLabelIndex values(18017,'模板模式') 
GO
INSERT INTO HtmlLabelInfo VALUES(18016,'普通模式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18016,'generic mode',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18017,'模板模式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18017,'templet mode',8) 
GO
INSERT INTO HtmlLabelIndex values(18018,'可编辑') 
GO
INSERT INTO HtmlLabelIndex values(18019,'必填') 
GO
INSERT INTO HtmlLabelInfo VALUES(18018,'可编辑',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18018,'can be edited',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18019,'必填',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18019,'must input',8) 
GO
INSERT INTO HtmlLabelIndex values(18020,'主表字段') 
GO
INSERT INTO HtmlLabelIndex values(18021,'明细表字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(18020,'主表字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18020,'main table field',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18021,'明细表字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18021,'detail table field',8) 
GO
INSERT INTO HtmlLabelIndex values(18023,'是否使用模板') 
GO
INSERT INTO HtmlLabelInfo VALUES(18023,'是否使用模板',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18023,'use mode or not',8) 
GO

INSERT INTO HtmlLabelIndex values(17139,'显示类型') 
GO
INSERT INTO HtmlLabelInfo VALUES(17139,'显示类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17139,'show type',8) 
GO
INSERT INTO HtmlLabelIndex values(18015,'流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(18015,'流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18015,'Workflow',8) 
GO
INSERT INTO HtmlLabelIndex values(18173,'显示/隐藏表头') 
GO
INSERT INTO HtmlLabelInfo VALUES(18173,'显示/隐藏表头',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18173,'show or hidden system head',8) 
go