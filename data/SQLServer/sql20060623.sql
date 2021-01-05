Declare
@id int,
@count int,
@all_cursor cursor
delete from SysPoppupRemindInfo where type=9
	
SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
select id from HrmResource
OPEN @all_cursor
FETCH NEXT FROM @all_cursor INTO @id
WHILE @@FETCH_STATUS = 0
BEGIN		
	select @count=count(id) from cowork_items where ((','+coworkers+',' like '%,'+CAST(@id AS varchar(50))+',%') or creater=CAST(@id AS varchar(50))) and (','+isnew+',' not like '%,'+CAST(@id AS varchar(50))+',%') and status=1
	IF (@count <> 0)
	BEGIN
		insert into SysPoppupRemindInfo(userid,type,usertype,statistic,remindcount,count) values(@id,9,'0','y',@count,@count)
	END
	FETCH NEXT FROM @all_cursor INTO @id
END
CLOSE @all_cursor
DEALLOCATE @all_cursor

GO
