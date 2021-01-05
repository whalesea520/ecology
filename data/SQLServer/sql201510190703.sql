CREATE trigger Prj_ProjectInfo_getCrm ON Prj_ProjectInfo FOR INSERT,UPDATE AS DECLARE @relateditemid int ,@managerview int,@description char(4000),@crmid int, @all_cursor cursor 
begin 
select distinct @relateditemid=id from deleted 
delete from Prj_ShareInfo where relateditemid = @relateditemid  and sharetype=9 
SELECT @managerview = managerview,@relateditemid=id,@description = description FROM inserted 
if @managerview=1
begin
 set @all_cursor =  CURSOR FORWARD_ONLY STATIC FOR select col as value from F_split(@description,',') 
 open @all_cursor 
 
begin
 FETCH NEXT FROM @all_cursor INTO @crmid 
 WHILE @@FETCH_STATUS = 0
 begin
 print @crmid 
insert into Prj_ShareInfo (relateditemid,sharetype,crmid) values 
 (@relateditemid,9,@crmid) 
	FETCH NEXT FROM @all_cursor INTO @crmid 
 end 
 close @all_cursor 
end
 end
else 
	begin
	delete from Prj_ShareInfo where relateditemid = @relateditemid  and sharetype=9 
	end

 end
 go