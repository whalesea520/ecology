declare
	maxid integer;

begin
select   max(id) into maxid  from workflow_formdict;

update SequenceIndex set currentid=maxid+1 where indexdesc='workflowformdictid';

end;
/