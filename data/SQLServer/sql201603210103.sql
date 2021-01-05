create  procedure Hplayout_eid_update(@hpid integer,@ebaseid varchar(50)) as 
declare t_cur cursor for select id from hpElement where isuse=1 and ebaseid=@ebaseid and hpid=@hpid
declare @s_id integer
declare @v_sql varchar(1000)
declare @sqlstr varchar(1000) 
begin
	set @v_sql = 'areaElements'
	open t_cur
	fetch next from  t_cur into @s_id
	WHILE @@FETCH_STATUS = 0  
	begin
		  set @v_sql = 'replace(' + @v_sql+','''+cast (@s_id as varchar) +','','''')'
		  fetch next from  t_cur into @s_id
	end
	close t_cur
	deallocate t_cur
	update hpElement set isuse = 0 where ebaseid=@ebaseid and hpid=@hpid
	set @v_sql = 'update hpLayout set areaElements ='+@v_sql+ ' where hpid='+cast (@hpid as varchar)
	execute(@v_sql)
end
GO