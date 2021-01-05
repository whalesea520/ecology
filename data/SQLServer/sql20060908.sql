INSERT INTO HtmlLabelIndex values(19664,'报表列') 
GO
INSERT INTO HtmlLabelInfo VALUES(19664,'报表列',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19664,'Report Column',8) 
GO

update HtmlLabelInfo set labelName='Report Condition'  where indexId=15505 and languageId=8
GO

insert into SequenceIndex(indexDesc,currentId) values('WorkflowRptCondMouldId',1)
GO


CREATE TABLE WorkflowRptCondMould (
	id int  NOT NULL ,
        mouldName varchar(200) NULL , 
        userId int NULL ,
        reportId int NULL 
) 
GO


CREATE TABLE WorkflowRptCondMouldDetail (
	id int IDENTITY (1, 1) NOT NULL ,
        mouldId int NULL , 
        fieldId int NULL ,
	isMain char(1)  NULL,
	isShow char(1)  NULL,
	isCheckCond char(1)  NULL,
	colName varchar(60)  NULL,
	htmlType char(1)  NULL,
        type int NULL ,
	optionFirst char(1)  NULL,
	valueFirst  varchar(60) NULL,
	nameFirst  varchar(60) NULL,
	optionSecond char(1)  NULL,
	valueSecond  varchar(60) NULL
) 
GO