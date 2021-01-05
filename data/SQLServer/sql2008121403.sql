CREATE TABLE workflow_shortNameSetting (
	id int identity (1, 1) not null,
	workflowId int null ,
	formId int null ,
	isBill char(1) null ,
	fieldId int null ,
	fieldValue int null ,
	shortNameSetting varchar(100) null 
)
GO

alter table workflow_code add fieldSequenceAlone char(1)  null
GO
alter table workflow_codeSeq add fieldId int  null
GO
alter table workflow_codeSeq add fieldValue int  null
GO

update workflow_codeSeq set fieldId=-1
GO
update workflow_codeSeq set fieldValue=-1
GO

insert into workflow_codeSet values(15,261,'5')
GO
