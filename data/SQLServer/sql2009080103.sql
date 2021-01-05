declare @requestid int
declare @currentnodeid int

declare initdocid_cursor cursor for 
	select requestid,currentnodeid from workflow_requestbase 	

open initdocid_cursor fetch next from initdocid_cursor into @requestid,@currentnodeid
while @@fetch_status=0 
begin 
	update 	workflow_currentoperator  set nodeid=@currentnodeid where requestid=@requestid and isremark=0 and nodeid is null
	fetch next from initdocid_cursor into @requestid,@currentnodeid
end 
close initdocid_cursor 
deallocate initdocid_cursor 

go