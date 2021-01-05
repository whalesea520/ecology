declare
	maxid integer;

begin
select   max(id) into maxid  from workflow_formdictdetail;

update SequenceIndex set currentid=maxid where indexdesc='workflowformdictid';

end;
/