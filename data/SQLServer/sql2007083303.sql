update workflow_browserurl set fieldDbType='text' where id=142
GO

alter table DocReceiveUnit alter column  receiverIds text null
GO

update workflow_formdict set fieldDbType='text' where fieldHtmlType='3' and type=142
GO

CREATE  PROCEDURE DocReceiveUnit_UpdateInfo
AS
Declare
        @fieldName varchar(40),
	@str_sql varchar(400)
begin
        declare fieldName_cursor cursor for select fieldName from workflow_formdict where fieldHtmlType='3' and type=142
        open fieldName_cursor fetch next from fieldName_cursor into @fieldName
	while @@fetch_status=0
	begin
	    EXEC   ('alter table workflow_form alter column   '+@fieldName+' text null')
	    fetch next from fieldName_cursor into @fieldName
	end
         close fieldName_cursor 
         deallocate fieldName_cursor
end
GO

EXECUTE DocReceiveUnit_UpdateInfo
GO

drop PROCEDURE DocReceiveUnit_UpdateInfo
GO
