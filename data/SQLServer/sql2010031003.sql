INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (74,'ApproveID',16409,'int',3,8,2,0,'')
GO

CREATE PROCEDURE workflow_74_init
AS
declare @workflowid int
declare @nodeid int
declare @fieldid int
select @fieldid=id from workflow_billfield where billid=74 and fieldname='ApproveID'

declare wf_cursor cursor for select id from workflow_base where formid=74
open wf_cursor fetch next from wf_cursor into @workflowid while(@@fetch_status = 0)
begin
	declare node_cursor cursor for select distinct(nodeid) from workflow_flownode where workflowid=@workflowid
	open node_cursor fetch next from node_cursor into @nodeid while(@@fetch_status = 0)
	begin
		insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory,orderid) values(@nodeid,@fieldid,1,0,0,0)
		fetch next from node_cursor into @nodeid
	end
	close node_cursor deallocate node_cursor
	fetch next from wf_cursor into @workflowid
end
close wf_cursor deallocate wf_cursor
GO
execute workflow_74_init
GO
DROP PROCEDURE workflow_74_init
GO
