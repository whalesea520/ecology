alter table moderightinfo add joblevel int
GO
alter table moderightinfo add jobleveltext varchar(4000)
GO
alter table mode_searchPageshareinfo add joblevel int
GO
alter table mode_searchPageshareinfo add jobleveltext varchar(4000)
GO
create PROCEDURE mode_right_col_alt
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
								
				select @existsisdefault=count(*) from sysobjects o,syscolumns c where o.id=c.id and upper(o.name)=upper('modedatashare_'+@TableIndex) and upper(c.name) = upper('joblevel')
				if @existsisdefault = 0
	      		begin
	      			set @sql='alter table modeDataShare_'+@TableIndex+' add joblevel int'
					exec (@sql)
					print @sql
					set @sql='alter table modeDataShare_'+@TableIndex+' add jobleveltext varchar(4000)'
					exec (@sql)
					print @sql			
				end

			end

		
	      	SELECT @tablename = 'modeDataShare_' + @TableIndex+'_set'
	      	select @existstable=count(*) from sysobjects where name=@tablename
	      	if @existstable = 1
	      	begin
								
				select @existsisdefault=count(*) from sysobjects o,syscolumns c where o.id=c.id and upper(o.name)=upper('modedatashare_'+@TableIndex+'_set') and upper(c.name) = upper('joblevel')
				if @existsisdefault = 0
	      		begin
	      			set @sql='alter table modeDataShare_'+@TableIndex+'_set add joblevel int'
					exec (@sql)
					print @sql

	      			set @sql='alter table modeDataShare_'+@TableIndex+'_set add jobleveltext varchar(4000)'
					exec (@sql)
					print @sql		
				end

			end
		FETCH NEXT FROM tableindex_cur INTO @TableIndex
	END
close tableindex_cur
DEALLOCATE tableindex_cur
GO
EXECUTE  mode_right_col_alt
go       
drop PROCEDURE mode_right_col_alt 
go
