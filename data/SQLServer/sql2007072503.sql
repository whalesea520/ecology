delete from workflow_codeSeq
GO
alter table workflow_codeSeq add formId int null
GO
alter table workflow_codeSeq add isBill char(1) null
GO