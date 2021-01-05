Create Procedure reset_CoworkRemind(
	@flag integer output , 
	@msg varchar(80) output)
as
	Declare
	@id int,
	@count int,
	@all_cursor cursor
		
	SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
	select id from HrmResource
	OPEN @all_cursor
	FETCH NEXT FROM @all_cursor INTO @id
	WHILE @@FETCH_STATUS = 0
	BEGIN		
		select @count=count(id) from cowork_items where ((coworkers like '%,'+CAST(@id AS varchar(50))+',%') or creater=CAST(@id AS varchar(50))) and (isnew not like '%,'+CAST(@id AS varchar(50))+',%') and status=1
		update SysPoppupRemindInfo set remindcount=@count,count=@count where userid=@id and type=9
		FETCH NEXT FROM @all_cursor INTO @id
	END
	CLOSE @all_cursor
	DEALLOCATE @all_cursor
GO