Declare
@id int,
@all_cursor cursor
SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
select id from codemain where id>1
OPEN @all_cursor
FETCH NEXT FROM @all_cursor INTO @id
WHILE @@FETCH_STATUS = 0
BEGIN		
	insert into codedetail(codemainid,showname,showtype,value,codeorder) values(@id,'19921','4','0',1)
	FETCH NEXT FROM @all_cursor INTO @id
END
CLOSE @all_cursor
DEALLOCATE @all_cursor
go

alter table codedetail add issecdoc char(1)
go
