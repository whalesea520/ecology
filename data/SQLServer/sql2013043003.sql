alter table modeinfo add DefaultShared char(1)
go
alter table modeinfo add NonDefaultShared char(1)
go

update modeinfo set DefaultShared = 0,NonDefaultShared=1
go

create PROCEDURE mode_createshareset_p
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
	      	SELECT @tablename = 'modeDataShare_' + @TableIndex + '_set'
	      	
	      	select @existstable=count(*) from sysobjects where name=@tablename
	      	if @existstable = 0
	      	begin
				set @sql='CREATE TABLE '+@tablename+' (
					id int IDENTITY (1, 1) NOT NULL ,
					sourceid int NOT NULL ,
					righttype int  NULL ,
					sharetype int  NULL ,
					relatedid int  NULL ,
					rolelevel int  NULL ,
					showlevel int  NULL ,
					isdefault int  NULL ,
					CONSTRAINT PK_'+@tablename+' PRIMARY KEY NONCLUSTERED (id ASC)
				)' 
				exec (@sql)
				
				set @sql='create index '+@tablename+'_IN on '+@tablename+' (sourceid,righttype,sharetype)'
				exec (@sql)
				
				select @existsisdefault=count(*) from sysobjects o,syscolumns c where o.id=c.id and upper(o.name)=upper('modedatashare_'+@TableIndex) and upper(c.name) = upper('isdefault')
				if @existsisdefault = 0
	      		begin
	      			set @sql='alter table modeDataShare_'+@TableIndex+' add isdefault int'
					exec (@sql)

	      			set @sql='update modeDataShare_'+@TableIndex+' set isdefault = 1'
					exec (@sql)
				end
				
				set @sql='insert into '+@tablename+'(sourceid,righttype,sharetype,relatedid,rolelevel,showlevel,isdefault) select sourceid,sharelevel,srcfrom,0 content,0 rolelevel,seclevel,isDefault from modeDataShare_' + @TableIndex + ' where srcfrom in (80,81,84,85) order by srcfrom asc'
				exec (@sql)
				
				set @sql='insert into '+@tablename+'(sourceid,righttype,sharetype,relatedid,rolelevel,showlevel,isdefault) select sourceid,sharelevel,type,content,0 rolelevel,seclevel,isDefault from modeDataShare_' + @TableIndex + ' where srcfrom in (1,2,3) order by srcfrom asc' 
				exec (@sql)
				
				set @sql='insert into '+@tablename+'(sourceid,righttype,sharetype,relatedid,rolelevel,showlevel,isdefault) select sourceid,sharelevel,type,SUBSTRING(convert(varchar(100),content),0,LEN(content)) content,min(SUBSTRING(convert(varchar(100),content),LEN(content),1)) rolelevel,seclevel,isDefault from modeDataShare_' + @TableIndex + ' where srcfrom = 4 group by sourceid,type,seclevel,sharelevel,srcfrom,SUBSTRING(convert(varchar(100),content),0,LEN(content)),isDefault'
				exec (@sql)
				
				set @sql='insert into '+@tablename+'(sourceid,righttype,sharetype,relatedid,rolelevel,showlevel,isdefault) select sourceid,sharelevel,type,0 content,0 rolelevel,seclevel,isDefault from modeDataShare_' + @TableIndex + ' where srcfrom = 5'
				exec (@sql)
				
				set @sql='insert into '+@tablename+'(sourceid,righttype,sharetype,relatedid,rolelevel,showlevel,isdefault) select sourceid,sharelevel,srcfrom,opuser,0 rolelevel,seclevel,isDefault from modeDataShare_' + @TableIndex + ' where srcfrom = 1000'
				exec (@sql)
				
			end
		FETCH NEXT FROM tableindex_cur INTO @TableIndex
	END
close tableindex_cur
DEALLOCATE tableindex_cur
GO
EXECUTE  mode_createshareset_p
go       
drop PROCEDURE mode_createshareset_p 
go