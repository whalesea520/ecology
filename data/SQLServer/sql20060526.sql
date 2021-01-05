
declare @docid int


declare initdocid_cursor cursor for select top 500 id from docdetail order by id desc	
open initdocid_cursor fetch next from initdocid_cursor into @docid
while @@fetch_status=0 
begin 
	exec Share_forDoc_init @docid   	
	fetch next from initdocid_cursor into @docid
end 
close initdocid_cursor 
deallocate initdocid_cursor
GO