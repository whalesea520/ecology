drop trigger trg_cptshr6_upd
go
create trigger trg_cptshr6_upd
on cptcapital
after update
as
if update(resourceid)
begin
	declare @new_resourceid int;
	declare @old_resourceid int;
	declare @isdata int;
	declare @newid int;
	declare my_cursor cursor for select inserted.resourceid,inserted.isdata,inserted.id,deleted.resourceid from inserted,deleted where inserted.id=deleted.id;
	open my_cursor
	fetch next from my_cursor into @new_resourceid,@isdata,@newid,@old_resourceid;
	while @@fetch_status=0
	begin
	   	if @isdata=1 fetch next from my_cursor into @new_resourceid,@isdata,@newid,@old_resourceid;
	   	if @isdata is null fetch next from my_cursor into @new_resourceid,@isdata,@newid,@old_resourceid;
	   	if @new_resourceid=@old_resourceid fetch next from my_cursor into @new_resourceid,@isdata,@newid,@old_resourceid;
	   	
		if @new_resourceid>0
		begin
			DELETE FROM CptCapitalShareInfo WHERE relateditemid=@newid AND sharetype=6 ;
		 	INSERT INTO [CptCapitalShareInfo] ( [relateditemid], [sharetype], [seclevel], [rolelevel], [sharelevel], [userid], [departmentid], [roleid], [foralluser],[subcompanyid],[isdefault])  
		 	VALUES ( @newid, 6, 0, null, 2, @new_resourceid, null, null, null,null,1);
		end
		fetch next from my_cursor into @new_resourceid,@isdata,@newid,@old_resourceid;
	end
	CLOSE my_cursor;
	DEALLOCATE my_cursor;
end
go