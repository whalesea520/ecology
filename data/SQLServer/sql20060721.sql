
CREATE TABLE workflow_nodeform_tmp (
	nodeid 		int 	NULL ,
	fieldid 	int 	NULL ,
	isview 		char (1)  NULL ,
	isedit 		char (1)  NULL ,
	ismandatory 	char (1)  NULL ,
	id		int IDENTITY (1, 1) NOT NULL
) 
GO

INSERT INTO workflow_nodeform_tmp(nodeid,fieldid,isview,isedit,ismandatory)
SELECT nodeid,fieldid,isview,isedit,ismandatory
FROM workflow_nodeform ORDER BY nodeid,fieldid
GO


declare c1 cursor for select nodeid,fieldid,min(id) as minid from workflow_nodeform_tmp group by nodeid,fieldid having count(fieldid)>1
open c1 
declare  @nodeid  int
declare  @fieldid int 
declare  @minid   int 
fetch next from c1 into @nodeid, @fieldid, @minid
while @@fetch_status=0 begin 
	delete from workflow_nodeform_tmp where nodeid=@nodeid and fieldid=@fieldid and id>@minid
	fetch next from c1 into @nodeid, @fieldid, @minid
end 
close c1 deallocate c1 
GO


delete from workflow_nodeform
GO


INSERT INTO workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory)
SELECT nodeid,fieldid,isview,isedit,ismandatory
FROM workflow_nodeform_tmp ORDER BY nodeid,fieldid
GO


drop table workflow_nodeform_tmp
go

declare c1 cursor for select id from workflow_formbase 
open c1 
declare  @formid  int
fetch next from c1 into @formid
while @@fetch_status=0 begin 
	delete from workflow_nodeform 
	where nodeid in(select b.nodeid from workflow_base a,workflow_flownode b where a.id=b.workflowid and a.isbill=0 and a.formid=@formid) 
	and fieldid not in(select fieldid from workflow_formfield where formid=@formid)
	fetch next from c1 into @formid
end 
close c1 deallocate c1 
GO