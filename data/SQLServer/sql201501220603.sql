create PROCEDURE mode_alert_p
AS 
DECLARE
	@TableIndex sysname, 
	@tablename varchar(100), 
	@sql varchar(1000),
	@existstable int,
	@existsisdefault int
DECLARE 
	tableindex_cur CURSOR FOR 
select id from modeinfo 
OPEN tableindex_cur 
FETCH NEXT FROM tableindex_cur INTO @TableIndex
WHILE @@fetch_status = 0
	BEGIN 
	    IF @@fetch_status = -2
	      CONTINUE	

		  SELECT @tablename = 'modeDataShare_' + @TableIndex
	      	select @existstable=count(*) from sysobjects where name=@tablename
	      	if @existstable = 1
	      	begin
								
				select @existsisdefault=count(*) from sysobjects o,syscolumns c where o.id=c.id and upper(o.name)=upper('modedatashare_'+@TableIndex) and upper(c.name) = upper('sharesetid')
				if @existsisdefault = 0
	      		begin
	      			set @sql='alter table modeDataShare_'+@TableIndex+' add sharesetid int'
					exec (@sql)
					print @sql
										
				end

			end

		
	      	SELECT @tablename = 'modeDataShare_' + @TableIndex+'_set'
	      	select @existstable=count(*) from sysobjects where name=@tablename
	      	if @existstable = 1
	      	begin
								
				select @existsisdefault=count(*) from sysobjects o,syscolumns c where o.id=c.id and upper(o.name)=upper('modedatashare_'+@TableIndex+'_set') and upper(c.name) = upper('isrolelimited')
				if @existsisdefault = 0
	      		begin
	      			set @sql='alter table modeDataShare_'+@TableIndex+'_set add isrolelimited int'
					exec (@sql)
					print @sql

	      			set @sql='alter table modeDataShare_'+@TableIndex+'_set add rolefieldtype int'
					exec (@sql)
					print @sql		
					
					set @sql='alter table modeDataShare_'+@TableIndex+'_set add rolefield int'
					exec (@sql)
					print @sql						
				end

			end
		FETCH NEXT FROM tableindex_cur INTO @TableIndex
	END
close tableindex_cur
DEALLOCATE tableindex_cur
GO
EXECUTE  mode_alert_p
go       
drop PROCEDURE mode_alert_p 
go