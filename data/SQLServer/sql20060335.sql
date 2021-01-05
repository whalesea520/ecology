declare @maxid int

select @maxid=max(id) from workflow_formdictdetail

update SequenceIndex set currentid=@maxid where indexdesc='workflowformdictid'
go