declare @maxid int

select @maxid=max(id) from workflow_formdict

update SequenceIndex set currentid=@maxid+1 where indexdesc='workflowformdictid'
go